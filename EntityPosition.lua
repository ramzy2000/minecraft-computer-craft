EntityPosition = {}

function EntityPosition:new(o, x, y, z)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.x = x
    o.y = y
    o.z = z
    return o
end

function EntityPosition:getX()
    return self.x
end

function EntityPosition:getY()
    return self.y
end

function EntityPosition:getZ()
    return self.z
end

function EntityPosition:print()
    print("X - " .. self.x)
    print("Y - " .. self.y)
    print("Z - " .. self.z)
end

-- add the position to a existing position
function EntityPosition:add(pos)
    result = EntityPosition:new(nil)
    result.x = self.x + pos.x
    result.y = self.y + pos.y
    result.z = self.z + pos.z
    return result
end

return EntityPosition
