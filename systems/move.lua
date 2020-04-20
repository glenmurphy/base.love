local MoveSystem = base.systemClass("MoveSystem")

function MoveSystem:requires()
  return {"Position", "Velocity"}
end

function MoveSystem:update(dt)
  for _, entity in pairs(self.targets) do
    local position = entity:get("Position")
    local velocity = entity:get("Velocity")
    position.x = position.x + velocity.x * dt
    position.y = position.y + velocity.y * dt
  end
end

return MoveSystem
