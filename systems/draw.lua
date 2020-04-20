local DrawSystem = base.systemClass("DrawSystem")

function DrawSystem:requires()
  return {"Position"}
end

function DrawSystem:draw(dt)
  for _, entity in pairs(self.targets) do
    local drawX = entity:get("Position").x
    local drawY = entity:get("Position").y

    -- prediction
    if entity:has("Velocity") then
      drawX = drawX + entity:get("Velocity").x * dt
      drawY = drawY + entity:get("Velocity").y * dt
    end

    love.graphics.rectangle("fill", drawX, drawY, 10, 10)
  end
end

return DrawSystem
