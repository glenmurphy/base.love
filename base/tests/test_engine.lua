require('unittest')

begin()

local Position = base.componentClass("Position")
local Velocity = base.componentClass("Velocity")

local SystemP = base.systemClass("SystemP")
function SystemP:requires()
  return {"Position"}
end

local SystemPV = base.systemClass("SystemPV")
function SystemPV:requires()
  return {"Position", "Velocity"}
end

local sysP = SystemP();
local engine = base.Engine()
engine:addSystem(sysP)

local entity1 = base.Entity()
entity1:add(Position())

test("sysP init", sysP.targets[entity1.id] == nil)

engine:addEntity(entity1)

test("sysP has entity1", sysP.targets[entity1.id] ~= nil)

local entity2 = base.Entity()
entity2:add(Position())
engine:addEntity(entity2)

test("e1 id autoincrement", entity1.id == 0)
test("e2 id autoincrement", entity2.id == 1)

local sysPV = SystemPV()
engine:addSystem(sysPV)

test("sysPV has not e1", sysPV.targets[entity1.id] == nil)
test("sysPV has not e2", sysPV.targets[entity2.id] == nil)

entity2:add(Velocity())

test("sysPV has not e1", sysPV.targets[entity1.id] == nil)
test("sysPV has e2", sysPV.targets[entity2.id] ~= nil)

-- TODO: TEST REMOVAL

finish()
