local application = require('hs.application')
local fnutils = require('hs.fnutils')
local hotkey = require('hs.hotkey')
local mouse = require('hs.mouse')
local screen = require('hs.screen')
local timer = require('hs.timer')
local window = require('hs.window')

local alt_ctrl = { 'alt', 'ctrl' }

-- Prefer the screen under the mouse, fall back to focused window, then main
local target_screen = function()
  return (mouse.getCurrentScreen and mouse.getCurrentScreen())
    or (window.focusedWindow() and window.focusedWindow():screen())
    or screen.mainScreen()
end

local main_window = function(bundle_id)
  local app = application.get(bundle_id)
  return app and app:mainWindow()
end

-- Wait for all windows to exist
local with_main_windows = function(bundle_ids, cb, tries)
  tries = tries or 25

  local step
  step = function()
    local wins = {}

    for i, bid in ipairs(bundle_ids) do
      wins[i] = main_window(bid)
      if not wins[i] then
        tries = tries - 1
        if tries > 0 then
          return timer.doAfter(0.1, step)
        end
        return
      end
    end

    cb(wins)
  end

  step()
end

local layout = function(items, opts)
  opts = opts or {}

  local bundle_ids = {}
  for i, it in ipairs(items) do
    bundle_ids[i] = it.bundle
  end

  return function()
    local scr = target_screen()
    local f = scr:frame()

    fnutils.each(bundle_ids, function(bid)
      application.launchOrFocusByBundleID(bid)
    end)

    with_main_windows(bundle_ids, function(wins)
      for i, it in ipairs(items) do
        -- Default to maximized
        local x = it.x or 0
        local y = it.y or 0
        local w = it.w or 1
        local h = it.h or 1

        wins[i]:moveToScreen(scr)
        wins[i]:setFrame({
          x = f.x + math.floor(f.w * x),
          y = f.y + math.floor(f.h * y),
          w = math.floor(f.w * w),
          h = math.floor(f.h * h),
        })
      end

      wins[opts.focus_index or 1]:focus()
    end)
  end
end

local apps = {
  beeper = 'com.automattic.beeper.desktop',
  kitty = 'net.kovidgoyal.kitty',
  music = 'com.apple.Music',
  obsidian = 'md.obsidian',
  safari = 'com.apple.Safari',
  slack = 'com.tinyspeck.slackmacgap',
  thunderbird = 'org.mozilla.thunderbird',
}

fnutils.each({
  { key = '1', func = layout({ { bundle = apps.kitty } }) },
  { key = '2', func = layout({ { bundle = apps.safari } }) },
  {
    key = '3',
    func = layout({
      { bundle = apps.slack, x = 0.00, w = 0.75 },
      { bundle = apps.beeper, x = 0.75, w = 0.25 },
    }),
  },
  { key = '4', func = layout({ { bundle = apps.obsidian } }) },
  { key = '5', func = layout({ { bundle = apps.thunderbird } }) },
  { key = '6', func = layout({ { bundle = apps.music } }) },
}, function(obj)
  hotkey.bind(
    -- Modifier
    obj.mod or alt_ctrl,
    -- Key
    obj.key,
    -- Function on pressed
    obj.func
  )
end)

-- vim: shiftwidth=2:
