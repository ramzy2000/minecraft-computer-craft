local EntityGlobalPos = {}

function EntityGlobalPos:new(o, filePath, initPos)
    o = o or {}
    setmetatable(o, self)
    self.__index = self

    if not filePath or filePath == "" then
        error("File path cannot be empty")
    end
    o.filePath = filePath

    -- If file does not exist, create it with the initial position
    if not fs.exists(o.filePath) then
        local file = fs.open(o.filePath, "w")
        if not file then
            error("Failed to create file at: " .. o.filePath)
        end
        file.writeLine(initPos or "0,0,0")
        file.close()
    end

    return o
end

function EntityGlobalPos:setPos(entityPos)
    -- Validate input
    if not entityPos or type(entityPos) ~= "table"
        or not entityPos.x or not entityPos.y or not entityPos.z then
        error("Invalid position data provided to setPos")
    end
    local result = entityPos.x .. "," .. entityPos.y .. "," .. entityPos.z

    local file = fs.open(self.filePath, "w+")
    if not file then
        error("Failed to open file for writing: " .. self.filePath)
    end
    file.write(result)
    file.close()
end

function EntityGlobalPos:getPos()
    local pos = vector.new(0, 0, 0)
    local file = fs.open(self.filePath, "r")
    if not file then
        error("Failed to open file for reading: " .. self.filePath)
    end
    local content = file.readAll()
    file.close()
    local numbers = {}

    -- Parse the stored string into coordinates
    for num in string.gmatch(content, "[^,]+") do
        table.insert(numbers, tonumber(num))
    end

    if #numbers == 3 then
        pos.x = numbers[1]
        pos.y = numbers[2]
        pos.z = numbers[3]
    else
        error("Corrupted position data in file: " .. self.filePath)
    end

    return pos
end

function EntityGlobalPos:exists()
    return fs.exists(self.filePath)
end

function EntityGlobalPos:delete()
    if fs.exists(self.filePath) then
        fs.delete(self.filePath)
    end
end

return EntityGlobalPos
