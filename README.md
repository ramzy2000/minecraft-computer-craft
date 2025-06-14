# minecraft-computer-craft

  <i><h1>TurtleEntity</h1></i> A TurtleEntity is an object that represents a self-aware turtle capable of performing various operations, such as navigating to specific world coordinates using the ComputerCraft GPS API. For TurtleEntity to function properly, a working GPS system is required. It is recommended to use GPS setups with Ender Modems for the best reliability.

 <ul>
     <li>function TurtleEntity:new(o) - Constructor</li>
     <li>function TurtleEntity:findFacingDirection() - find the current direction being faced</li>
     <li>function TurtleEntity:faceDirection(x, y, z) - face the direction inputed</li>
     <li>function TurtleEntity:moveTo(destination) - command the turtle to move to a destination in the world</li>
     <li>function TurtleEntity:moveHome() - command the turtle to return to its home position</li>
     <li>function TurtleEntity:getLookBlockName() - get the block name of the blook being looked at</li>
 </ul>

 <i><h1>EntityGlobalPos</h1></i> A class that permanently saves a position, even after the machine is shut down. This is useful when position data needs to be persisted to disk..

 <ul>
     <li>function EntityGlobalPos:new(o, filePath, initPos) - Constructor will create the file path if dose not exist. If already exists loads into memory</li>
     <li>function EntityGlobalPos:setPos(entityPos) - Update the position in the file</li>
     <li>function EntityGlobalPos:getPos() - Get the position that is stored on the file</li>
 </ul>
