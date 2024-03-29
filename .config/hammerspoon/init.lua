-- Just be instant please
hs.window.animationDuration = 0

-- Auto reload when config file changes
hs.pathwatcher.new(os.getenv('HOME') .. '/.config/hammerspoon/', hs.reload):start()

-- Modifier to use
local mod   = { 'alt', 'ctrl' }
local shift = { 'alt', 'ctrl', 'shift' }

-- General operations on window size
function push(x, y, w, h)
  local win = hs.window.frontmostWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w * x)
  f.y = max.y + (max.h * y)
  f.w = max.w * w
  f.h = max.h * h

  win:setFrame(f)
end

-- Vertical maximize of window
function maximize()
  local win = hs.window.frontmostWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.h = max.h
  f.y = max.y

  win:setFrame(f)
end

-- EvilWM
local shifty = 16

function resize(x, y)
  local win = hs.window.frontmostWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.w = f.w + (shifty * x)
  f.h = f.h + (shifty * y)

  --[[
  print('-----------')
  print('f.x: ' .. f.x .. ', f.w: ' .. f.w)
  print('f.y: ' .. f.y .. ', f.h: ' .. f.h)
  print('max.x: ' .. max.x .. ', max.y: ' .. max.y)
  print('max.w: ' .. max.w .. ', max.h: ' .. max.h)
  --]]

  win:setFrame(f)
end

function move(x, y)
  local win = hs.window.frontmostWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = f.x + (shifty * x)
  f.y = f.y + (shifty * y)

  if (f.x < 0) then
    f.x = 0
  end

  if (f.x + f.w > max.w) then
    f.x = max.w - f.w
  end

  if (f.y + f.h > max.h + max.y) then
    if (y > 0) then
      f.y = max.h - f.h + max.y - 1
    else
      f.y = 0
    end
  end

  win:setFrame(f)
end

-- Bind all these keys
hs.fnutils.each({
  -- Open / Focus an app
  { key = '1', app = 'iTerm'    },
  { key = '2', app = 'Safari'   },
  -- { key = '3', app = 'Messages' },
  { key = '4', app = 'Finder'   },

  -- Custom function
  { key = '=', func = maximize }, -- Vertical Maximize

  -- Movement
  { key = 'H', func = move, pos = { -1,  0 }}, -- Left
  { key = 'J', func = move, pos = {  0,  1 }}, -- Down
  { key = 'K', func = move, pos = {  0, -1 }}, -- Up
  { key = 'L', func = move, pos = {  1,  0 }}, -- Right

  -- Resizing
  { key = 'H', func = resize, mod = shift, pos = { -1,  0 }}, -- Left
  { key = 'J', func = resize, mod = shift, pos = {  0,  1 }}, -- Left
  { key = 'K', func = resize, mod = shift, pos = {  0, -1 }}, -- Left
  { key = 'L', func = resize, mod = shift, pos = {  1,  0 }}, -- Left

  -- All other keys call 'push'
  { key = 'Return', pos = {  0,  0,  1,  1 }},  -- Full
  { key = 'Up',     pos = {  0,  0,  1, .5 }},  -- Top Half
  { key = 'Right',  pos = { .5,  0, .5,  1 }},  -- Right Half
  { key = 'Down',   pos = {  0, .5,  1, .5 }},  -- Bottom Half
  { key = 'Left',   pos = {  0,  0, .5,  1 }},  -- Left Half

  { key = 'X',      pos = {  0,  0,  1,  1 }},  -- Full

  { key = 'Y',      pos = {  0,  0, .5, .5 }},  -- Upper Left Half
  { key = 'U',      pos = { .5,  0, .5, .5 }},  -- Upper Right Half
  { key = 'B',      pos = {  0, .5, .5, .5 }},  -- Bottom Left Half
  { key = 'N',      pos = { .5, .5, .5, .5 }}   -- Bottom Right Half

}, function(obj)
  local func = function()
    local app   = obj.app or nil
    local func  = obj.func or push
    local pos   = obj.pos or {}

    if (app == nil) then
      func(table.unpack(pos))
    else
      hs.application.launchOrFocus(app)
    end
  end

  local mod = obj.mod or mod

  -- modifier, key, pressed, released, repeated
  hs.hotkey.bind(mod, obj.key, func, nil, func)
end)

function decode(str)
  return string.gsub(str, '%%(%x%x)', function (hex) return string.char(tonumber(hex, 16)) end)
end

function clean_amazon(contents, i, j)
  return string.sub(contents, i, j - string.len('/ref='))
end

function clean_google(contents, i, j)
  i, j = string.find(contents, '[&%?]url=.+&')
  return decode(string.sub(contents, i + string.len('&url='), j - 1))
end

function clean_generic(contents, i, j)
  return contents
end

cleaners = {
  { key = '^https?://www%.amazon%.%a+/.+ref=', func = clean_amazon },
  { key = '^https?://www%.google%.%a+/url', func = clean_google },
  { key = '^https?://', func = clean_generic }
}

-- Clipboard cleaning for URLs
function clean(s)
  if s ~= nil then
    contents = s
    hs.fnutils.some(cleaners, function(obj)
      i, j = string.find(contents, obj.key)
      if i == nil then
        return false
      end
      contents = obj.func(contents, i, j)
      return true
    end)

    if contents ~= s then
      hs.pasteboard.writeObjects(contents)
    end
  end
end

hs.pasteboard.watcher.new(clean)

-- Caffeine alternative
local caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setIcon('./caffeine-on.pdf')
  else
    caffeine:setIcon('./caffeine-off.pdf')
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle('displayIdle'))
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get('displayIdle'))
end

