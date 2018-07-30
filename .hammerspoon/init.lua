--[[
I busted the right 3mm or so of my screen
so everything is designed to handle that
--]]

hs.window.animationDuration = 0

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', hs.reload):start()

-- Column of 9 pixels I've broken on the right of my screen..
-- local screenBreak = 0.00703125
-- eh.. it might be 10px now
-- nvm.. it's 41 now
local screenBreak = 0.03125
-- 1280 * x - 9 = 0, x = 0.00703125

function push(x, y, w, h)
  local win = hs.window.frontmostWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  max.w = max.w - (max.w * screenBreak)

  f.x = max.x + (max.w * x)
  f.y = max.y + (max.h * y)
  f.w = max.w * w
  f.h = max.h * h

  win:setFrame(f)
end

local mod = { 'alt', 'ctrl' }

hs.fnutils.each({
  { key = 'Return', pos = {  0,  0,  1,  1 }},  -- Full
  { key = 'Up',     pos = {  0,  0,  1, .5 }},  -- Top Half
  { key = 'Right',  pos = { .5,  0, .5,  1 }},  -- Right Half
  { key = 'Down',   pos = {  0, .5,  1, .5 }},  -- Bottom Half
  { key = 'Left',   pos = {  0,  0, .5,  1 }},  -- Left Half

  { key = 'X',      pos = {  0,  0,  1,  1 }},  -- Full
  { key = 'K',      pos = {  0,  0,  1, .5 }},  -- Top Half
  { key = 'L',      pos = { .5,  0, .5,  1 }},  -- Right Half
  { key = 'J',      pos = {  0, .5,  1, .5 }},  -- Bottom Half
  { key = 'H',      pos = {  0,  0, .5,  1 }},  -- Left Half

  { key = 'Y',      pos = {  0,  0, .5, .5 }},  -- Upper Left Half
  { key = 'U',      pos = { .5,  0, .5, .5 }},  -- Upper Right Half
  { key = 'B',      pos = {  0, .5, .5, .5 }},  -- Bottom Left Half
  { key = 'N',      pos = { .5, .5, .5, .5 }}   -- Bottom Right Half
}, function(obj)
  hs.hotkey.bind(mod, obj.key, function()
    push(table.unpack(obj.pos))
  end)
end)

hs.fnutils.each({
  { key = '1', app = 'iTerm'    },
  { key = '2', app = 'Safari'   },
  { key = '3', app = 'Messages' },
  { key = '4', app = 'Finder'   }
}, function(obj)
  hs.hotkey.bind(mod, obj.key, function()
    hs.application.launchOrFocus(obj.app)
  end)
end)

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

