-- TurtleEntity: Enhanced ComputerCraft Turtle Controller

local TurtleEntityBase = require("TurtleEntityBase")

local TurtleEntity = setmetatable({}, { __index = TurtleEntityBase })
EntityGlobalPos = require("EntityGlobalPos")

local blocksToMine = {
    ["minecraft:iron_ore"] = true,
    ["minecraft:gold_ore"] = true,
    ["minecraft:diamond_ore"] = true,
    ["minecraft:lapis_ore"] = true
}

function TurtleEntity:new(o)
    o = TurtleEntityBase.new(self, o)
    -- Your TurtleEntity-specific initialization here
    o.isRunning = true
    o.homePos = EntityGlobalPos:new(nil, "homePos.txt", "9,91,236")
    return o
end

function TurtleEntity:performTask()
    print("Moving to work position...")
    self:moveTo(vector.new(407, 56, 336))

    sleep(5)

    print("Returning home...")
    self:moveHome()

    sleep(5)
end

return TurtleEntity
