--[[
I busted the right 3mm or so of my screen
so everything is designed to handle that
--]]

hs.window.animationDuration = 0

hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', hs.reload):start()

-- The amount of pixels I've broken on the right of my screen..
local screenBreak = 9

function move(pos)
  local win = hs.window.frontmostWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local poses = {
    full = {
      x = max.x,
      y = max.y,
      w = max.w - screenBreak,
      h = max.h
    },

    up = {
      x = max.x,
      y = max.y,
      w = max.w - screenBreak,
      h = max.h / 2
    },

    right = {
      x = (max.x + (max.w / 2)) - screenBreak,
      y = max.y,
      w = max.w / 2,
      h = max.h
    },

    down = {
      x = max.x,
      y = max.y + (max.h / 2),
      w = max.w - screenBreak,
      h = max.h / 2
    },

    left = {
      x = max.x,
      y = max.y,
      w = max.w / 2,
      h = max.h
    },
  }

  win:setFrame(poses[pos])
end

local mod = { 'alt', 'ctrl' }
hs.fnutils.each({
  { key = 'Return', pos = 'full' },
  { key = 'Up', pos = 'up' },
  { key = 'Right', pos = 'right' },
  { key = 'Down', pos = 'down' },
  { key = 'Left', pos = 'left' }
}, function(obj)
  hs.hotkey.bind(mod, obj.key, function()
    move(obj.pos)
  end)
end)

-- heh
hs.alert.show('Hammerspoon loaded 👍')

