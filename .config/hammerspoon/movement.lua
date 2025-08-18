-- local application = require('hs.application')
local fnutils = require('hs.fnutils')
local hotkey = require('hs.hotkey')
local window = require('hs.window')

-- Modifiers to use
local alt_cmd = { 'alt', 'cmd' }
local alt_ctrl = { 'alt', 'ctrl' }
local ctrl_cmd = { 'ctrl', 'cmd' }

-- General operations on window size
local push = function(x, y, w, h)
  local win = window.frontmostWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w * x)
  f.y = max.y + (max.h * y)
  f.w = max.w * w
  f.h = max.h * h

  win:setFrame(f)
end

-- Bind all these keys
fnutils.each({
  { key = 'Return', pos = { 0, 0, 1, 1 } }, -- Full
  { key = 'X', pos = { 0, 0, 1, 1 } }, -- Full

  -- 50%
  { key = 'Up', pos = { 0, 0, 1, 0.5 } }, -- Top Half
  { key = 'Right', pos = { 0.5, 0, 0.5, 1 } }, -- Right Half
  { key = 'Down', pos = { 0, 0.5, 1, 0.5 } }, -- Bottom Half
  { key = 'Left', pos = { 0, 0, 0.5, 1 } }, -- Left Half

  -- 70%
  { key = 'Up', mod = ctrl_cmd, pos = { 0, 0, 1, 0.7 } }, -- Top 70%
  { key = 'Right', mod = ctrl_cmd, pos = { 0.3, 0, 0.7, 1 } }, -- Right 70%
  { key = 'Down', mod = ctrl_cmd, pos = { 0, 0.3, 1, 0.7 } }, -- Bottom 70%
  { key = 'Left', mod = ctrl_cmd, pos = { 0, 0, 0.7, 1 } }, -- Left 70%

  -- 30%
  { key = 'Up', mod = alt_cmd, pos = { 0, 0, 1, 0.3 } }, -- Top 30%
  { key = 'Right', mod = alt_cmd, pos = { 0.7, 0, 0.3, 1 } }, -- Right 30%
  { key = 'Down', mod = alt_cmd, pos = { 0, 0.7, 1, 0.3 } }, -- Bottom 30%
  { key = 'Left', mod = alt_cmd, pos = { 0, 0, 0.3, 1 } }, -- Left 30%

  { key = 'Y', pos = { 0, 0, 0.5, 0.5 } }, -- Upper Left Half
  { key = 'U', pos = { 0.5, 0, 0.5, 0.5 } }, -- Upper Right Half
  { key = 'B', pos = { 0, 0.5, 0.5, 0.5 } }, -- Bottom Left Half
  { key = 'N', pos = { 0.5, 0.5, 0.5, 0.5 } }, -- Bottom Right Half
}, function(obj)
  local func = function()
    local func = obj.func or push
    local pos = obj.pos or {}

    func(table.unpack(pos))
  end

  hotkey.bind(
    -- Modifier
    obj.mod or alt_ctrl,
    -- Key
    obj.key,
    -- Function on pressed
    func,
    -- Function on released
    nil,
    -- Function on repeated
    func
  )
end)

-- vim: shiftwidth=2:
