TurtleEntity = { isRunning = true }

EntityPosition = require("EntityPosition")
EntityGlobalPos = require("EntityGlobalPos")

local blocksToMine = {
    ["minecraft:iron_ore"] = true,
    ["minecraft:gold_ore"] = true,
    ["minecraft:diamond_ore"] = true,
    ["minecraft:lapis_ore"] = true
}

-- Derived class method newproxy
function TurtleEntity:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.isRunning = true
    self.width = 3
    self.height = 3
    o.currentGlobalPos = EntityGlobalPos:new(nil, "homepos.txt", "0,0,0")
    o.forwardGlobalVec = EntityGlobalPos:new(nil, "forwardVec.txt", "1,0,0")
    return o
end

function TurtleEntity:moveHome()
    self:moveTo(EntityPosition:new(nil, 0, 0, 0))
end

function TurtleEntity:moveTo(targetPos)
    local currentPos = self.currentGlobalPos:getPos()
    local forwardVec = self.forwardGlobalVec:getPos()

    local dx = targetPos.x - currentPos.x
    local dy = targetPos.y - currentPos.y

    -- Move along X axis
    if dx ~= 0 then
        local desiredXDir = dx > 0 and 1 or -1
        self:faceDirection(desiredXDir, 0)
        for i = 1, math.abs(dx) do
            self:MoveForward()
        end
    end

    -- Move along Y axis
    if dy ~= 0 then
        local desiredYDir = dy > 0 and 1 or -1
        self:faceDirection(0, desiredYDir)
        for i = 1, math.abs(dy) do
            self:MoveForward()
        end
    end
end

function TurtleEntity:faceDirection(dx, dy)
    local currentVec = self.forwardGlobalVec:getPos()

    local function vectorsEqual(a, b)
        return a.x == b.x and a.y == b.y
    end

    local desiredVec = { x = dx, y = dy }

    -- Try to turn until the forwardVec matches desiredVec
    for _ = 1, 4 do
        if vectorsEqual(currentVec, desiredVec) then
            return
        end
        self:TurnRight()
        currentVec = self.forwardGlobalVec:getPos()
    end
end

function TurtleEntity:MoveForward()
    -- get the current position of the turtleEntity
    position = self.currentGlobalPos:getPos()
    forwardVec = self.forwardGlobalVec:getPos()

    -- move the turtle forward once
    sucess = turtle.forward()
    if (sucess == true) then
        -- update the global position
        position.x = position.x + forwardVec.x
        position.y = position.y + forwardVec.y

        self.currentGlobalPos:setPos(position)
    end
end

function TurtleEntity:TurnLeft()
    forwardVec = self.forwardGlobalVec:getPos()
    if forwardVec.x == 1 then
        forwardVec.x = 0
        forwardVec.y = 1
    elseif forwardVec.y == 1 then
        forwardVec.x = -1
        forwardVec.y = 0
    elseif forwardVec.x == -1 then
        forwardVec.x = 0
        forwardVec.y = -1
    elseif forwardVec.y == -1 then
        forwardVec.x = 1
        forwardVec.y = 0
    end
    turtle.turnLeft()
    self.forwardGlobalVec:setPos(forwardVec)
end

function TurtleEntity:TurnRight()
    forwardVec = self.forwardGlobalVec:getPos()
    if forwardVec.x == 1 then
        forwardVec.x = 0
        forwardVec.y = -1
    elseif forwardVec.y == 1 then
        forwardVec.x = 1
        forwardVec.y = 0
    elseif forwardVec.x == -1 then
        forwardVec.x = 0
        forwardVec.y = 1
    elseif forwardVec.y == -1 then
        forwardVec.x = -1
        forwardVec.y = 0
    end
    turtle.turnRight()
    self.forwardGlobalVec:setPos(forwardVec)
end

function TurtleEntity:findDirection()
    if turtle.detect() then
        directionFound = false
        while not directionFound do
            turtle.turnLeft()
            if not turtle.detect() then
                directionFound = true
            end
        end
    end
end

function TurtleEntity:getLookBlockName()
    local success, data = turtle.inspect()
    if success then
        return data.name
    else
        return ""
    end
end

return TurtleEntity
