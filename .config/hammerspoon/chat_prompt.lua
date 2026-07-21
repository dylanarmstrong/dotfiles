--[[
ChatGPT quick prompt

Purpose:
- Adds a dedicated Option-Space launcher in addition to the Command-Space Seal picker.
- Opens a compact prompt composer near the bottom of the active screen.
- Sends submitted text to https://chatgpt.com/?q=<encoded prompt>, which asks
  ChatGPT to start the prompt automatically in the user's browser session.

UX goals:
- Resemble the official ChatGPT desktop composer without copying inapplicable
  model or tool controls.
- Stay visually compact for short prompts while allowing longer text to wrap.
- Use Atkinson Hyperlegible Next at 16 px and the preferred palette declared
  in the embedded CSS.
- Keep the webview transparent with enough outer padding for an unclipped,
  rounded shadow.

Interaction rules:
- Return submits; Shift-Return inserts a newline.
- Escape or loss of focus dismisses the popup.
- Showing and hiding use the same very fast fade.
- Every dismissal clears the field before hiding so stale text never flashes
  when the popup is opened again.
- Showing explicitly activates Hammerspoon, focuses the webview window, then
  focuses the textarea. The short focus guard prevents the initial activation
  sequence from being mistaken for a user-initiated blur.

Implementation note:
- This uses hs.webview rather than hs.chooser because the chooser does not
  expose the query field typography needed for this design.
]]--

local application = require('hs.application')
local hotkey = require('hs.hotkey')
local http = require('hs.http')
local mouse = require('hs.mouse')
local screen = require('hs.screen')
local timer = require('hs.timer')
local urlevent = require('hs.urlevent')
local webview = require('hs.webview')
local usercontent = require('hs.webview.usercontent')
local window = require('hs.window')

local target_screen = function()
  return (mouse.getCurrentScreen and mouse.getCurrentScreen())
    or (window.focusedWindow() and window.focusedWindow():screen())
    or screen.mainScreen()
end

local html = [[
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <style>
      :root {
        --black: #151515;
        --blue: #133dc8;
        --red: #e21352;
        --white: #fafafa;
      }

      * {
        box-sizing: border-box;
      }

      html,
      body {
        align-items: center;
        background: transparent;
        display: flex;
        height: 100%;
        justify-content: center;
        margin: 0;
        overflow: hidden;
        width: 100%;
      }

      body {
        padding: 14px 20px 18px;
      }

      .popup {
        align-items: center;
        background: var(--white);
        border: 1px solid rgba(21, 21, 21, 0.12);
        border-radius: 28px;
        box-shadow:
          0 8px 18px -6px rgba(21, 21, 21, 0.12),
          0 2px 7px -3px rgba(21, 21, 21, 0.07);
        display: flex;
        height: 100%;
        overflow: hidden;
        width: 100%;
      }

      textarea {
        align-content: center;
        background: transparent;
        border: 0;
        caret-color: var(--blue);
        color: var(--black);
        font-family: "Atkinson Hyperlegible Next", sans-serif;
        font-size: 16px;
        flex: 1;
        height: 100%;
        line-height: 1.35;
        min-width: 0;
        outline: none;
        overflow-y: auto;
        padding: 0 10px 0 18px;
        resize: none;
        width: auto;
      }

      textarea::selection {
        background: rgba(19, 61, 200, 0.22);
      }

      textarea::placeholder {
        color: var(--black);
        opacity: 0.5;
      }

      button {
        align-items: center;
        background: rgba(21, 21, 21, 0.14);
        border: 0;
        border-radius: 50%;
        color: white;
        display: flex;
        flex: 0 0 auto;
        height: 32px;
        justify-content: center;
        margin-right: 12px;
        padding: 0;
        transition:
          background 120ms ease,
          transform 120ms ease;
        width: 32px;
      }

      button.ready {
        background: var(--blue);
        cursor: pointer;
      }

      button.ready:active {
        transform: scale(0.94);
      }

      svg {
        height: 17px;
        width: 17px;
      }
    </style>
  </head>
  <body>
    <main class="popup">
      <textarea
        id="prompt"
        autocomplete="off"
        placeholder="Ask anything"
        rows="1"
        spellcheck="true"
      ></textarea>
      <button id="send" aria-label="Send" type="button">
        <svg aria-hidden="true" viewBox="0 0 20 20">
          <path
            d="M10 15V5M10 5 5.8 9.2M10 5l4.2 4.2"
            fill="none"
            stroke="currentColor"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2.2"
          />
        </svg>
      </button>
    </main>
    <script>
      const input = document.getElementById("prompt");
      const send = document.getElementById("send");

      const updateSendButton = () => {
        send.classList.toggle("ready", input.value.trim().length > 0);
      };

      const submit = () => {
        const prompt = input.value.trim();
        if (!prompt) return;

        input.value = "";
        updateSendButton();
        webkit.messageHandlers.chatPrompt.postMessage({
          action: "submit",
          prompt,
        });
      };

      window.clearPrompt = () => {
        input.value = "";
        updateSendButton();
      };

      window.resetPrompt = () => {
        window.clearPrompt();
        input.focus();
      };

      input.addEventListener("input", updateSendButton);

      input.addEventListener("keydown", (event) => {
        if (event.key === "Escape") {
          event.preventDefault();
          window.clearPrompt();
          webkit.messageHandlers.chatPrompt.postMessage({ action: "cancel" });
          return;
        }

        if (event.key === "Enter" && !event.shiftKey) {
          event.preventDefault();
          submit();
        }
      });

      send.addEventListener("click", submit);
    </script>
  </body>
</html>
]]

local chat_prompt
local can_hide_on_blur = false
local fade_duration = 0.06
local show_generation = 0
local controller = usercontent.new('chatPrompt')

local hide_chat_prompt = function()
  can_hide_on_blur = false
  show_generation = show_generation + 1
  if chat_prompt then
    chat_prompt:evaluateJavaScript('window.clearPrompt && window.clearPrompt()', function()
      chat_prompt:hide(fade_duration)
    end)
  end
end

controller:setCallback(function(message)
  local body = message.body or message

  if body.action == 'cancel' then
    hide_chat_prompt()
    return
  end

  if body.action == 'submit' and body.prompt and body.prompt ~= '' then
    hide_chat_prompt()
    urlevent.openURL('https://chatgpt.com/?q=' .. http.encodeForQuery(body.prompt))
  end
end)

chat_prompt = webview
  .new({ x = 0, y = 0, w = 600, h = 94 }, {}, controller)
  :allowTextEntry(true)
  :html(html)
  :shadow(false)
  :transparent(true)
  :windowStyle({ 'borderless' })

chat_prompt:windowCallback(function(action, _, state)
  if action == 'focusChange' and not state and can_hide_on_blur then
    hide_chat_prompt()
  end
end)

hotkey.bind({ 'alt' }, 'space', function()
  local frame = target_screen():frame()
  local width = math.min(600, frame.w - 20)
  show_generation = show_generation + 1
  local generation = show_generation
  can_hide_on_blur = false

  chat_prompt
    :frame({
      h = 94,
      w = width,
      x = frame.x + math.floor((frame.w - width) / 2),
      y = frame.y + frame.h - 118,
    })
    :show(fade_duration)
    :bringToFront(true)

  timer.doAfter(0.05, function()
    if generation ~= show_generation then
      return
    end

    local app = application.get('org.hammerspoon.Hammerspoon')
    local prompt_window = chat_prompt:hswindow()

    if app then
      app:activate(true)
    end
    if prompt_window then
      prompt_window:focus()
    end

    chat_prompt:evaluateJavaScript('window.resetPrompt && window.resetPrompt()')
  end)

  timer.doAfter(0.12, function()
    if generation == show_generation then
      can_hide_on_blur = true
    end
  end)
end)
