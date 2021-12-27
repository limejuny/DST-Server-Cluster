-- Created by abcdef

return function (obj)
    if obj == nil then
        obj = {}
    end
    obj.mt = { __index = obj }
    obj.call = { __call = function (...)
        return obj:new(...)
    end
    }
    return setmetatable(obj, obj.call)
end