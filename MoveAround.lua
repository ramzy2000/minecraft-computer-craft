-- Meta class
Controller = { isRunning = true }

-- Derived class method newproxy
function Controller:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.isRunning = true
    return o
end

function Controller:findDirection()
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

function Controller:run()
    while self.isRunning do
        -- check if the turtle is out of fuel
        if turtle.getFuelLevel() < 2 then
            turtle.refuel()
        end

        -- find the direction we want to move
        self:findDirection()

        -- move the turtle
        turtle.forward()
    end
end

controller = Controller:new(nil)
controller:run()
