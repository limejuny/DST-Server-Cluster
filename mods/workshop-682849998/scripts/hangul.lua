-- Hangul IME 2.0.0
-- Created by abcdef

local constants = require "cons"
local Instance = require "instance"
local Jamo = require "jamo"

local initial   = constants.initial
local medial    = constants.medial
local final     = constants.final
local conversions = { Y='y', U='u', I='i', A='a', S='s', D='d', F='f', G='g', H='h', J='j', K='k', L='l', Z='z', X='x', C='c', V='v', B='b', N='n', M='m'}

local Hangul = Instance()

function Hangul:new(self)
    local o = {}
    o.jamo = Jamo()
    o.pre_jamo = nil
    return setmetatable(o, Hangul.mt)
end

function Hangul:Input(str)
    if self.pre_jamo ~= nil then
        self.pre_jamo = nil
    end
    if conversions[str] then 
        str = conversions[str]
    end

    local jamo_part = self:FindJamoPart(str, self.jamo)
    
    if jamo_part.jamo_type == Jamo.JAMO_TYPES.unknown then
        if self.jamo:toString() ~= nil then
            self.pre_jamo = self.jamo
        end
        self.jamo = Jamo()
        jamo_part = self:FindJamoPart(str, self.jamo, self.pre_jamo)

        if jamo_part.jamo_type == Jamo.JAMO_TYPES.medial then
            if self.pre_jamo.final ~= nil then
                local final_string = self.pre_jamo:StringOfValue(Jamo.JAMO_TYPES.final)
                if string.len(final_string) == 2 then
                    self.pre_jamo:SetJamo(Jamo.JAMO_TYPES.final, final[string.sub(final_string,1,1)])
                    final_string = string.sub(final_string,#final_string)
                else
                    self.pre_jamo:SetJamo(Jamo.JAMO_TYPES.final, nil)
                end
                self.jamo:SetJamo(Jamo.JAMO_TYPES.initial, initial[final_string])
            end
        end
    elseif self.jamo.unknown ~= nil then
        self.pre_jamo = self.jamo
        self.jamo = Jamo()
    end

    if jamo_part.jamo_type == Jamo.JAMO_TYPES.unknown then
        self.jamo:SetJamo(jamo_part.jamo_type, str)
    else
        self.jamo:SetJamo(jamo_part.jamo_type, jamo_part.value)
    end
    
end 

function Hangul:FindJamoPart(str, jamo, pre_jamo)
    local initialValue = initial[str]
    local medialValue = medial[str]
    local finalValue = final[str]
    local function toJamoValue(jamo_type, s, value)
        return { jamo_type=jamo_type, source=s, value=value }
    end

    
    if initialValue ~= nil then
        if jamo.initial == nil and medialValue == nil then
            return toJamoValue(Jamo.JAMO_TYPES.initial, str, initialValue)
        end
    end

    
    if medialValue ~= nil then
        if initialValue == nil and finalValue == nil then 
            if jamo.final == nil then
                if jamo.medial ~= nil then
                    local medial_string = jamo:StringOfValue(Jamo.JAMO_TYPES.medial) .. str
                    local medial_temp = medial[medial_string]
                    if jamo.initial ~= nil and medial_temp ~= nil then
                        return toJamoValue(Jamo.JAMO_TYPES.medial, medial_string, medial_temp)
                    end
                else
                    return toJamoValue(Jamo.JAMO_TYPES.medial, str, medialValue)
                end
            end
        end
    end

    
    if finalValue ~= nil and jamo.medial ~= nil then
        if jamo.final ~= nil then
            local final_string = jamo:StringOfValue(Jamo.JAMO_TYPES.final) .. str
            local final_temp = final[final_string]
            if final_temp ~= nil then
                return toJamoValue(Jamo.JAMO_TYPES.final, final_string, final_temp)
            end
        elseif medialValue == nil then
            return toJamoValue(Jamo.JAMO_TYPES.final, str, finalValue)
        end
    end
    return toJamoValue(Jamo.JAMO_TYPES.unknown, str, nil)
end

function Hangul:Delete()
    local jamo_type = 
    (self.jamo.unknown and Jamo.JAMO_TYPES.unknown or nil) or 
    (self.jamo.final and Jamo.JAMO_TYPES.final or nil) or 
    (self.jamo.medial and Jamo.JAMO_TYPES.medial or nil) or 
    (self.jamo.initial and Jamo.JAMO_TYPES.initial or nil) or nil
    
    if jamo_type ~= nil then
        if jamo_type == Jamo.JAMO_TYPES.medial or jamo_type == Jamo.JAMO_TYPES.final then
            local str = self.jamo:StringOfValue(jamo_type)
            if #str == 2 then
                str = string.sub(str,1,1)
                self.jamo:SetJamo(jamo_type, jamo_type == Jamo.JAMO_TYPES.medial and medial[str] or final[str])
                return
            end
        end
        self.jamo:SetJamo(jamo_type)
    end
end

function table.indexOf(t, value)
    for k, v in pairs(t) do
        if v == value then
            return k
        end
    end
    return -1
end

return Hangul