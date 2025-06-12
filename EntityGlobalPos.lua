EntityPosition = require("EntityPosition")

EntityGlobalPos = {}

function EntityGlobalPos:new(o, filePath, initPos)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.filePath = filePath

    if filePath == "" then
        return
    end

    -- check if file exists
    if (not fs.exists(self.filePath)) then
        -- if not then create one with a base pos of 0, 0, 0
        file = fs.open(self.filePath, "w")
        if file then
            file.writeLine(initPos)
            file.close()
        end
    end

    return o
end

function EntityGlobalPos:setPos(entityPos)
    -- convert the position into a string
    result = entityPos.x .. "," .. entityPos.y .. "," .. entityPos.z
    -- write this position to the file
    file = fs.open(self.filePath, "w+")
    file.write(result)
    file.close()
end

function EntityGlobalPos:getPos()
    pos = EntityPosition:new(nil, 0, 0, 0)
    file = fs.open(self.filePath, "r")
    content = ""
    if file then
        content = file.readAll()
    end
    numbers = {}
    -- parse out the text into the numbers
    for num in string.gmatch(content, "[^,]+") do
        table.insert(numbers, tonumber(num))
    end
    pos.x = numbers[1]
    pos.y = numbers[2]
    pos.z = numbers[3]
    return pos
end

return EntityGlobalPos
