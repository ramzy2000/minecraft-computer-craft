local TurtleEntity = require("TurtleEntity")

local turtleEntity = TurtleEntity:new(nil)

while true do
    print("Moving to work position...")
    turtleEntity:moveTo(vector.new(9, 91, 231))

    sleep(5)

    print("Returning home...")
    turtleEntity:moveHome()

    sleep(5)
    break
end
