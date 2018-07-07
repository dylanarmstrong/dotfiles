--[[
I busted the right 3mm or so of my screen
so everything is designed to handle that
--]]

hs.window.animationDuration = 0

hs.hotkey.bind({'alt', 'ctrl'}, 'Left', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'Right', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = (max.x + (max.w / 2)) - 9
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'Return', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w - 9
  f.h = max.h
  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'Up', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w - 9
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'Down', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + (max.h / 2)
  f.w = max.w - 9
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'U', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y / 2
  f.w = max.w /2
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'J', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y + (max.h / 2)
  f.w = max.w /2
  f.h = max.h / 2
  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'I', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = (max.x + (max.w / 2)) - 9
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h / 2

  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'K', function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = (max.x + (max.w / 2)) - 9
  f.y = max.y + (max.h / 2)
  f.w = max.w / 2
  f.h = max.h / 2

  win:setFrame(f)
end)

hs.hotkey.bind({'alt', 'ctrl'}, 'R', function()
  hs.reload()
end)

--[[
--
-- nifty caffeine replacement from docs
-- TODO: Find higher res coffee icon to replace caffinate.
--
caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle('AWAKE')
  else
    caffeine:setTitle('SLEEPY')
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle('displayIdle'))
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get('displayIdle'))
end
--]]

