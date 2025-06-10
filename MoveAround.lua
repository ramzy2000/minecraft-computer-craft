function findDirection()
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

function run()
    isAwake = true
    while isAwake do
        -- check if the turtle is out of fuel
        if turtle.getFuelLevel() < 2 then
            turtle.refuel()
        end

        -- find the direction we want to move
        findDirection()

        -- move the turtle
        turtle.forward()
    end
end

run()
