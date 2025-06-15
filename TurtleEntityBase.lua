-- TurtleEntityBase.lua
-- Base class for all Turtle entities

EntityGlobalPos = require("EntityGlobalPos")

-- Cardinal direction vectors
local directionVectors = {
    north = vector.new(0, 0, -1),
    east  = vector.new(1, 0, 0),
    south = vector.new(0, 0, 1),
    west  = vector.new(-1, 0, 0)
}

-- Helper to move a number of steps in a direction
local function moveSteps(direction, count)
    for step = 1, count do
        local success
        if direction == "forward" then
            success = turtle.forward()
        elseif direction == "up" then
            success = turtle.up()
        elseif direction == "down" then
            success = turtle.down()
        end
        if not success then
            print("Movement failed at step " .. step .. " in direction " .. direction)
            return false
        end
    end
    return true
end

local TurtleEntityBase = {}

function TurtleEntityBase:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.homePos = nil
    o.forwardPos = nil
    self:init()
    return o
end

function TurtleEntityBase:findFacingDirection()
    local x, y, z = gps.locate()
    if not x then
        error("GPS locate failed. Ensure GPS towers are in range.")
    end
    local firstPos = vector.new(x, y, z)
    if not turtle.forward() then
        error("Cannot move forward to detect facing direction.")
    end
    local x2, y2, z2 = gps.locate()
    local secondPos = vector.new(x2, y2, z2)
    turtle.back()
    local directionFacing = secondPos - firstPos
    self.forwardPos = directionFacing
end

-- Example: Method for initialization; override in subclasses if needed
function TurtleEntityBase:init()
    -- placeholder for subclass initialization
    self.homePos = EntityGlobalPos:new(nil, "homePos.txt", "407, 56, 344") -- Still default, but can be changed
    self.forwardPos = vector.new(0, 0, 0)
    self:findFacingDirection()
end

-- Move to a destination vector
function TurtleEntityBase:moveTo(destination)
    local x, y, z = gps.locate()
    if not x then
        error("GPS locate failed. Cannot move to destination.")
    end
    local currentLocation = vector.new(x, y, z)
    local distVec = destination - currentLocation
    local desiredDir = distVec:normalize()

    -- Move along Z
    if (desiredDir.z > 0) then
        self:faceDirection(0, 0, 1)
        if not moveSteps("forward", math.abs(distVec.z)) then return end
    elseif (desiredDir.z < 0) then
        self:faceDirection(0, 0, -1)
        if not moveSteps("forward", math.abs(distVec.z)) then return end
    end

    -- Move along X
    if (desiredDir.x > 0) then
        self:faceDirection(1, 0, 0)
        if not moveSteps("forward", math.abs(distVec.x)) then return end
    elseif (desiredDir.x < 0) then
        self:faceDirection(-1, 0, 0)
        if not moveSteps("forward", math.abs(distVec.x)) then return end
    end

    -- Move along Y
    if (desiredDir.y > 0) then
        if not moveSteps("up", math.abs(distVec.y)) then return end
    elseif (desiredDir.y < 0) then
        if not moveSteps("down", math.abs(distVec.y)) then return end
    end
end

function TurtleEntityBase:faceDirection(x, y, z)
    local desiredDirection = vector.new(x, y, z)
    if (desiredDirection.x == 0 and desiredDirection.z == 0) then
        return
    end

    -- Helper: compare vectors by their values
    local function sameVec(a, b)
        return a.x == b.x and a.y == b.y and a.z == b.z
    end

    -- Rotate until facing the correct direction
    local tries = 0
    while not sameVec(desiredDirection, self.forwardPos) do
        tries = tries + 1
        if tries > 4 then
            error("Too many rotation attempts. Stuck in faceDirection.")
        end
        if sameVec(self.forwardPos, directionVectors.east) then
            if sameVec(desiredDirection, directionVectors.west) then
                turtle.turnLeft(); turtle.turnLeft()
                self.forwardPos = directionVectors.west
            elseif sameVec(desiredDirection, directionVectors.north) then
                turtle.turnLeft()
                self.forwardPos = directionVectors.north
            elseif sameVec(desiredDirection, directionVectors.south) then
                turtle.turnRight()
                self.forwardPos = directionVectors.south
            end
        elseif sameVec(self.forwardPos, directionVectors.north) then
            if sameVec(desiredDirection, directionVectors.west) then
                turtle.turnLeft()
                self.forwardPos = directionVectors.west
            elseif sameVec(desiredDirection, directionVectors.east) then
                turtle.turnRight()
                self.forwardPos = directionVectors.east
            elseif sameVec(desiredDirection, directionVectors.south) then
                turtle.turnLeft(); turtle.turnLeft()
                self.forwardPos = directionVectors.south
            end
        elseif sameVec(self.forwardPos, directionVectors.west) then
            if sameVec(desiredDirection, directionVectors.north) then
                turtle.turnRight()
                self.forwardPos = directionVectors.north
            elseif sameVec(desiredDirection, directionVectors.east) then
                turtle.turnRight(); turtle.turnRight()
                self.forwardPos = directionVectors.east
            elseif sameVec(desiredDirection, directionVectors.south) then
                turtle.turnLeft()
                self.forwardPos = directionVectors.south
            end
        elseif sameVec(self.forwardPos, directionVectors.south) then
            if sameVec(desiredDirection, directionVectors.north) then
                turtle.turnRight(); turtle.turnRight()
                self.forwardPos = directionVectors.north
            elseif sameVec(desiredDirection, directionVectors.east) then
                turtle.turnLeft()
                self.forwardPos = directionVectors.east
            elseif sameVec(desiredDirection, directionVectors.west) then
                turtle.turnRight()
                self.forwardPos = directionVectors.west
            end
        end
    end
end

-- Set the home position dynamically
function TurtleEntityBase:setHomeHere()
    local x, y, z = gps.locate()
    if not x then
        error("GPS locate failed. Cannot set home position.")
    end
    self.homePos:setPos(vector.new(x, y, z))
    print("Home position set to: " .. x .. "," .. y .. "," .. z)
end

-- Move to the home position
function TurtleEntityBase:moveHome()
    self:moveTo(self.homePos:getPos())
end

-- Inspect the block in front and return its name, or nil if no block
function TurtleEntityBase:getLookBlockName()
    local success, data = turtle.inspect()
    if success and data and data.name then
        return data.name
    else
        return nil
    end
end

-- Check if the block ahead is in blocksToMine and mine it if so
function TurtleEntityBase:mineIfTargetBlock()
    local blockName = self:getLookBlockName()
    if blockName and blocksToMine[blockName] then
        turtle.dig()
        print("Mined block: " .. blockName)
        return true
    end
    return false
end

-- Example: Virtual method for performing the turtle's main task
function TurtleEntityBase:performTask()
    error("performTask must be implemented by subclass")
end

return TurtleEntityBase
