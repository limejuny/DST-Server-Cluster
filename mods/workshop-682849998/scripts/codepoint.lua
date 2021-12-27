-- Created by abcdef

local Instance = require "instance"

local CodePoint = Instance()

function CodePoint:new(self, startpoint, value)
    local o = {}
    o.value = value
    o.point = startpoint + value
    return setmetatable(o, CodePoint.mt)
end

function CodePoint:toUtf8()
    return ConvertToUtf8(self.point)
end

function GetByte(a, b)
    return a - math.floor(a/b) * b
end

function ConvertToUtf8(unicode)
	if unicode and unicode > 0 then
		if unicode >= 0x800 and unicode <= 0xD800 then
			local b1 = math.floor(GetByte(unicode, 0x010000) / 0x1000)
			local b2 = math.floor(GetByte(unicode, 0x001000) / 0x40)
            local b3 = GetByte(unicode, 0x000040)
			return string.char(b1 + 0xE0, b2 + 0x80, b3 + 0x80)
		end
	end
end

return CodePoint