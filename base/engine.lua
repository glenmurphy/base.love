local folder = (...):match("(.-)[^%/%.]+$")
local class = require(folder .. "class")

function isTarget(entity, system)
  local components = entity:getComponents()
  local requires = system:requires()

  for i, requirement in pairs(requires) do
    if not components[requirement] then return false end
  end
  return true
end

local Engine = class()

function Engine:init()
  self.systems = {}
  self.entities = {}
  self.components = {}
end

function Engine:addSystem(system)
  table.insert(self.systems, system)

  -- Targets: Add appropriate entities to system
  for i, entity in pairs(self.entities) do
    if isTarget(entity, system) then
      system:addTarget(entity)
    end
  end
end

function Engine:addToTargets(entity)
  for i, system in pairs(self.systems) do
    if isTarget(entity, system) then
      system:addTarget(entity)
    end
  end
end

function Engine:removeFromTargets(entity)
  for i, system in pairs(self.systems) do
    if not isTarget(entity, system) then
      system:removeTarget(entity)
    end
  end
end

function Engine:addEntity(entity)
  -- TODO: Add to matching targets in systems
  table.insert(self.entities, entity)

  entity:setEngine(self)

  self:addToTargets(entity)
end

function Engine:removeEntity(entity)
  for i, v in pairs(self.entities) do
    if v == entity then
      table.remove(self.entities, i)
      return
    end
  end

  -- Targets: Remove from targets in matching systems
  for i, system in pairs(self.systems) do
    -- this is cheap enough we can just do it rather than checking
    system:removeTarget(entity)
  end
end

-- Called by an entity when its components change after being added to engine
function Engine:componentAdded(entity, component)
  self:addToTargets(entity)
end

-- Called by an entity when its components change after being added to engine
function Engine:componentRemoved(entity, component)
  self:removeFromTargets(entity)
end

function Engine:update(dt)
  for _, system in ipairs(self.systems) do
    system:update(dt)
  end
end

function Engine:draw(dt)
  for _, system in ipairs(self.systems) do
    system:draw(dt)
  end
end

return Engine
