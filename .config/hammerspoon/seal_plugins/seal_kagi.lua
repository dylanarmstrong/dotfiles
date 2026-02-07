-- ~/.config/hammerspoon/seal_plugins/seal_kagi.lua
-- Just a simple plugin for seal that is always available and opens kagi
local obj = {}
obj.__index = obj
obj.__name = 'seal_kagi'
obj.__icon = hs.image.imageFromName(hs.image.systemImageNames.NSTouchBarSearchTemplate)

function obj:commands()
  return {}
end

function obj:bare()
  return self.bareSearch
end

function obj.bareSearch(query)
  if query == nil or query == '' then
    return {}
  end

  -- This requires your session to be active in your browser. I can't be bothered to figure out how
  -- to hide my session token, so no auth is going to be added here.
  local url = 'https://kagi.com/search?q=' .. hs.http.encodeForQuery(query)

  return {
    {
      image = obj.__icon,
      plugin = obj.__name,
      subText = query,
      text = 'Search with Kagi',
      type = 'openURL',
      url = url,
    },
  }
end

function obj.completionCallback(row)
  hs.urlevent.openURL(row.url)
end

return obj
