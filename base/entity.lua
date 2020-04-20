local folder = (...):match("(.-)[^%/%.]+$")
local class = require(folder .. "class")
local Entity = class()
local entityID = 0

function Entity:init()
  self.components = {}
  self.engine = nil

  self.id = entityID
  entityID = entityID + 1
end

function Entity:setEngine(engine)
  self.engine = engine
end

function Entity:getComponents()
  return self.components
end

function Entity:add(component)
  self.components[component.name] = component
  if self.engine then self.engine:componentAdded(self, component) end
end

function Entity:remove(component)
  table.remove(self.components, component.name)
  if self.engine then self.engine:componentRemoved(self, component) end
end

function Entity:has(componentName)
  if self.components[componentName] then return true end
  return false
end

function Entity:get(componentName)
  return self.components[componentName]
end

return Entity
