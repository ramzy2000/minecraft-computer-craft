EntityPosition = require("EntityPosition")

TurtleEntity = require("TurtleEntity")
turtleEntity = TurtleEntity:new(nil)
turtleEntity:moveTo(EntityPosition:new(nil, 3, 4, 0))

sleep(5)

turtleEntity:moveHome()

turtleEntity:moveTo(EntityPosition:new(nil, 3, 4, 0))

sleep(5)

turtleEntity:moveHome()
