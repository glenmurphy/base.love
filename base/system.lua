local folder = (...):match("(.-)[^%/%.]+$")
local class = require(folder .. "class")
local System = class()

function System:init()
  self.targets = {}
end

function System:requires()
  return {} -- component names
end

function System:addTarget(entity)
  self.targets[entity.id] = entity
end

function System:removeTarget(entity)
  self.targets[entity.id] = nil
end

function System.update(dt)
end

function System:draw(dt)
end

return function(name)
  local s = class(System)
  s.name = name
  return s
end
