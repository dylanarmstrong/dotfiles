local fnutils = require('hs.fnutils')
local pasteboard = require('hs.pasteboard')

local decode = function(str)
  return string.gsub(str, '%%(%x%x)', function (hex) return string.char(tonumber(hex, 16)) end)
end

local clean_amazon = function(contents, i, j)
  return string.sub(contents, i, j - string.len('/ref='))
end

local clean_google = function(contents, i, j)
  i, j = string.find(contents, '[&%?]url=.+&')
  return decode(string.sub(contents, i + string.len('&url='), j - 1))
end

local clean_generic = function(contents)
  return contents
end

local cleaners = {
  { key = '^https?://www%.amazon%.%a+/.+ref=', func = clean_amazon },
  { key = '^https?://www%.google%.%a+/url', func = clean_google },
  { key = '^https?://', func = clean_generic }
}

-- Clipboard cleaning for URLs
local clean = function(s)
  if s ~= nil then
    local contents = s
    fnutils.some(cleaners, function(obj)
      local i, j = string.find(contents, obj.key)
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

pasteboard.watcher.new(clean)

-- vim: shiftwidth=2:
