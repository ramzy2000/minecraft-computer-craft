TurtleEntity = { isRunning = true }

EntityGlobalPos = require("EntityGlobalPos")

local blocksToMine = {
    ["minecraft:iron_ore"] = true,
    ["minecraft:gold_ore"] = true,
    ["minecraft:diamond_ore"] = true,
    ["minecraft:lapis_ore"] = true
}

-- Cardinal direction vectors (north, east, south, west)
local directionVectors = {
    north = vector.new(0, 0, -1),
    east = vector.new(1, 0, 0),
    south = vector.new(0, 0, 1),
    west = vector.new(-1, 0, 0)
}

function TurtleEntity:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.homePos = EntityGlobalPos:new(nil, "homePos.txt", "9,91,236")
    os.forwardPos = vector.new(0, 0, 0)
    self:findFacingDirection()
    return o
end

function TurtleEntity:findFacingDirection()
    -- first get the current position
    local firstPos = vector.new(gps.locate())

    -- move forward one
    turtle.forward()

    -- get the second position
    local secondPos = vector.new(gps.locate())

    turtle.back()

    -- calcuate the direction we are facing
    local directionFacing = secondPos - firstPos

    -- set the facing direction
    self.forwardPos = directionFacing
end

function TurtleEntity:faceDirection(desiredDirection)
    while not (desiredDirection == self.forwardPos) do
        print("made it here")
        if self.forwardPos == directionVectors.east then
            if (desiredDirection == directionVectors.west) then
                self.forwardPos = directionVectors.west
                turtle.turnLeft()
                turtle.turnLeft()
            elseif (desiredDirection == directionVectors.north) then
                self.forwardPos = directionVectors.north
                turtle.turnLeft()
            elseif (desiredDirection == directionVectors.south) then
                self.forwardPos = directionVectors.south
                turtle.turnRight()
            end
        elseif self.forwardPos == directionVectors.north then
            if (desiredDirection == directionVectors.west) then
                self.forwardPos = directionVectors.west
                turtle.turnLeft()
            elseif (desiredDirection == directionVectors.east) then
                self.forwardPos = directionVectors.north
                turtle.turnRight()
            elseif (desiredDirection == directionVectors.south) then
                self.forwardPos = directionVectors.south
                turn.turnLeft()
                turn.turnLeft()
            end
        elseif self.forwardPos == directionVectors.west then
            if desiredDirection == directionVectors.north then
                self.forwardPos = directionVectors.north
                turtle.turnRight()
            elseif desiredDirection == directionVectors.east then
                self.forwardPos = directionVectors.east
                turtle.turnRight()
                turtle.turnRight()
            elseif desiredDirection == directionVectors.south then
                self.forwardPos = directionVectors.south
                turtle.turnLeft()
            end
        elseif self.forwardPos == directionVectors.south then
            if desiredDirection == directionVectors.north then
                self.forwardPos = directionVectors.north
                turtle.turnRight()
                turtle.turnRight()
            elseif desiredDirection == directionVectors.east then
                self.forwardPos = directionVectors.east
                turtle.turnLeft()
            elseif desiredDirection == directionVectors.west then
                self.forwardPos = directionVectors.west
                turtle.turnRight()
            end
        end
    end
end

function TurtleEntity:moveTo(destination)
    -- get the current direction facing

    local currentLocation = vector.new(gps.locate())

    local distVec = destination - currentLocation

    local desiredDir = distVec:normalize()

    self:faceDirection(desiredDir)
end

function TurtleEntity:moveHome()
    self:moveTo(self.homePos:getPos())
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
