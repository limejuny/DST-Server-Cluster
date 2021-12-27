-- Created by abcdef

local constants = require "cons"
local Instance = require "instance"
local CodePoint = require "codepoint"

local Jamo = Instance()
Jamo.JAMO_TYPES = { unknown=-1, completed=0, initial=1, medial=2, final=3  }

function Jamo:new(self, initialValue, medialValue, finalValue)
    local o = {}
    o.initial   = initialValue and self:CodePoint(self.JAMO_TYPES.initial,initialValue) or nil
    o.medial    = medialValue and self:CodePoint(self.JAMO_TYPES.medial,medialValue) or nil
    o.final     = finalValue and self:CodePoint(self.JAMO_TYPES.final,finalValue) or nil
    o.unknown   = nil

    local completed = self:CompletedCodePoint(initialValue, medialValue, finalValue)
    o.completed = self:CodePoint(self.JAMO_TYPES.completed,completed)

    return setmetatable(o, Jamo.mt)
end

function Jamo:CodePoint(jamoType, value)
    local startpoint = nil
    if self.JAMO_TYPES.initial == jamoType then
        startpoint = 0x1100
    elseif self.JAMO_TYPES.medial == jamoType then
        startpoint = 0x1161
    elseif self.JAMO_TYPES.final == jamoType then
        startpoint = 0x11A8
    elseif self.JAMO_TYPES.completed == jamoType then
        startpoint = 0xAC00
    else
        return nil
    end

    return CodePoint(startpoint, value)
end

function Jamo:CompletedCodePoint(initial, medial, final)
    return ((((initial or 0) * 21) + (medial or 0)) * 28 + (final or 0))
end

function Jamo:Update()
    local codepoint = self:CompletedCodePoint(self.initial and self.initial.value, self.medial and self.medial.value, self.final and self.final.value)
    self.completed =self:CodePoint(self.JAMO_TYPES.completed,codepoint)
end

function Jamo:SetJamo(jamoType, value, update)
    local codepoint = value and self:CodePoint(jamoType, value) or nil
    if self.JAMO_TYPES.initial == jamoType then
        self.initial = codepoint
    elseif self.JAMO_TYPES.medial == jamoType then
        self.medial = codepoint
    elseif self.JAMO_TYPES.final == jamoType then
        self.final = codepoint
    else
        self.unknown = value
    end
    
    if update ~= nil or update ~= false then
        self:Update()
    end
end

function Jamo:GetJamo(jamoType)
    if self.JAMO_TYPES.initial == jamoType then
        return self.initial
    elseif self.JAMO_TYPES.medial == jamoType then
        return self.medial
    elseif self.JAMO_TYPES.final == jamoType then
        return self.final
    elseif self.JAMO_TYPES.completed == jamoType then
        return self.completed
    else
        return nil
    end
end

function Jamo:StringOfValue(jamoType)
    if self.JAMO_TYPES.initial == jamoType then
        return table.indexOf(constants.initial, self.initial.value)
    elseif self.JAMO_TYPES.medial == jamoType then
        return table.indexOf(constants.medial, self.medial.value)
    elseif self.JAMO_TYPES.final == jamoType then
        return table.indexOf(constants.final, self.final.value)
    else
        return nil
    end
end

function Jamo:isEmpty()
    return self.initial == nil and self.medial == nil and self.final == nil
end

function Jamo:toString()
    if self.initial and self.medial then
        return self.completed:toUtf8()
    else
        local j = self.initial or self.medial or self.final
        if j ~= nil then
            return j:toUtf8()
        elseif self.unknown ~= nil then
            return self.unknown
        end
    end
end

return Jamo