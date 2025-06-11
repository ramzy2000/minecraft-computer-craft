MoveForwardCommand = require("MoveForwardCommand")
RefuelCommand = require("RefuleCommand")

InputManager = {}

function InputManager:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self._moveForwardCommand = MoveForwardCommand()
    self._refuelCommand = RefuelCommand()
    return o
end

function handelInput()
    if not turtle.detect() then
        return _moveForwardCommand
    else

    end

    if turtle.getFuelLevel() < 2 then
        return _refuelCommand
    end
    return nil
end

return InputManager
