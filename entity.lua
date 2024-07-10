-- Define a new class called Entity
local flux = require "flux"

Entity = {}
Entity.__index = Entity

-- Constructor
function Entity:new(name, position)
    local instance = setmetatable({}, Entity)
    instance.name = name
    instance.position = position or {x = 0, y = 0}
    return instance
end

-- Method to move the entity
function Entity:move(newPosition)
    self.position = newPosition
end

-- Method to display entity information
function Entity:display()
    print("Entity Name: " .. self.name)
    print("Position: (" .. self.position.x .. ", " .. self.position.y .. ")")
end
