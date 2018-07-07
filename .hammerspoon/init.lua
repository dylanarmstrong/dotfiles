--[[
I busted the right 3mm or so of my screen
so everything is designed to handle that
--]]

-- The amount of pixels I've broken on the right of my screen..
local screenBreak = 9

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', hs.reload):start()

hs.window.animationDuration = 0

function move(pos)
  local win = hs.window.focusedWindow()
  local screen = win:screen()
  local max = screen:frame()
  local poss = {
    full = {
      x = max.x,
      y = max.y,
      w = max.w - screenBreak,
      h = max.h
    },
    left = {
      x = max.x,
      y = max.y,
      w = max.w / 2,
      h = max.h
    },
    right = {
      x = (max.x + (max.w / 2)) - screenBreak,
      y = max.y,
      w = max.w / 2,
      h = max.h
    },
    up = {
      x = max.x,
      y = max.y,
      w = max.w - screenBreak,
      h = max.h / 2
    },
    down = {
      x = max.x,
      y = max.y + (max.h / 2),
      w = max.w - screenBreak,
      h = max.h / 2
    }
  }

  local f = poss[pos]
  return function()
    win:setFrame(f)
  end
end

local mod = { 'alt', 'ctrl' }
hs.fnutils.each({
  { key = 'return', pos = 'full' },
  { key = 'left', pos = 'left' },
  { key = 'right', pos = 'right' },
  { key = 'up', pos = 'up' },
  { key = 'down', pos = 'down' }
}, function(obj)
  hs.hotkey.new(mod, obj.key, move(obj.pos)):enable()
end)

