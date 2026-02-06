local window = require('hs.window')

require('movement')
require('pasteboard')
require('tiling')

-- Just be instant please when moving windows
window.animationDuration = 0

-- Used to install plugins for hammerspoon
hs.loadSpoon('SpoonInstall')

-- Hammerspoon lua annotations for lsp server
spoon.SpoonInstall:andUse('EmmyLua')

-- Auto reload when config file changes
spoon.SpoonInstall:andUse('ReloadConfiguration', { start = true })

-- Caffeine replacement to keep screen awake as desired
spoon.SpoonInstall:andUse('Caffeine', { start = true })

-- Round corners to match natural rounded corners of MacOS
spoon.SpoonInstall:andUse('RoundedCorners', { config = { radius = 10 }, start = true })

-- When editing this, it's helpful to know when it's actually reloaded successfully
-- hs.alert.show('Hammerspoon Loaded')

-- vim: shiftwidth=2:
