local window = require('hs.window')

require('movement')
require('workspaces')

-- Just be instant please when moving windows
window.animationDuration = 0

-- Used to install plugins for hammerspoon
hs.loadSpoon('SpoonInstall')

-- Hammerspoon lua annotations for lsp server
spoon.SpoonInstall:andUse('EmmyLua')

-- Auto reload when config file changes
spoon.SpoonInstall:andUse('ReloadConfiguration', {
  start = true,
})

-- Caffeine replacement to keep screen awake as desired
spoon.SpoonInstall:andUse('Caffeine', {
  start = true,
})

-- Round corners to match natural rounded corners of MacOS
spoon.SpoonInstall:andUse('RoundedCorners', {
  config = {
    radius = 10,
  },
  start = true,
})

spoon.SpoonInstall:andUse('Seal', {
  hotkeys = {
    show = {
      { 'cmd' },
      'Space',
    },
  },
  fn = function(seal)
    seal:loadPlugins({ 'apps', 'calc', 'kagi' })

    -- I want kagi to always appear last
    local originalChoicesCallback = seal.choicesCallback
    seal.choicesCallback = function()
      local choices = originalChoicesCallback()
      local results, kagi = {}, {}
      for _, c in ipairs(choices) do
        if c.plugin == 'seal_kagi' then
          table.insert(kagi, c)
        else
          table.insert(results, c)
        end
      end
      for _, c in ipairs(kagi) do
        table.insert(results, c)
      end
      return results
    end

    seal.chooser:choices(seal.choicesCallback)
  end,
  start = true,
})

-- When editing this, it's helpful to know when it's actually reloaded successfully
-- hs.alert.show('Hammerspoon Loaded')
