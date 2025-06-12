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

function TurtleEntity:MoveForward()
    -- get the current position of the turtleEntity
    position = self.currentGlobalPos:getPos()
    forwardVec = self.forwardGlobalVec:getPos()

    -- move the turtle forward once
    turtle.forward()

    -- update the global position
    position.x = position.x + forwardVec.x
    position.y = position.y + forwardVec.y

    self.currentGlobalPos:setPos(position)
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

function TurtleEntity:Testing()
    --self:MoveForward()
    self:MoveForward()
end

function TurtleEntity:MoveAround()
    while self.isRunning do
        -- check if the turtle is out of fuel
        if turtle.getFuelLevel() < 2 then
            turtle.refuel()
        end

        lookBlockName = self:getLookBlockName()
        if not lookBlockName == "" then
            if not blocksToMine[lookBlockName] == nil then
                turtle.dig()
            end
        end

        -- find the direction we want to move
        self:findDirection()

        -- move the turtle
        turtle.forward()
    end
end

function TurtleEntity:MoveAroundTest()
    xPos = 0
    yPos = 0
    direction = 1

    while self.isRunning do
        -- check if the turtle is out of fuel
        if turtle.getFuelLevel() < 2 then
            turtle.refuel()
        end

        if (xPos < self.width) then
            xPos = xPos + 1
            turtle.forward()
            print(xPos)
        else
            if (yPos < self.height) then
                if (direction == 1) then
                    -- turn the turtle to left
                    turtle.turnLeft()
                    -- move forward
                    turtle.forward()
                    yPox = yPos + 1
                    -- turn the turtle to the left again
                    turtle.turnLeft()
                elseif (direction == -1) then
                    -- turn the turtle to left
                    turtle.turnRight()
                    -- move forward
                    turtle.forward()
                    yPox = yPos + 1
                    -- turn the turtle to the left again
                    turtle.turnRight()
                end

                xPos = 0 -- reset the x position
                direction = direction * -1
            end
        end
    end
end

return TurtleEntity
