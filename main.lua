require("base/base")

local ticksPerSecond = 10
local tickTime = 1 / ticksPerSecond
local accumulator = 0

local Position = require("components/position")
local Velocity = require("components/velocity")
local MoveSystem = require("systems/move")
local DrawSystem = require("systems/draw")

function love.load()
  local player = base.Entity()
  player:init()
  player:add(Position(150, 25))
  player:add(Velocity(100, 100))

  engine = base.Engine()
  engine:addEntity(player)
  engine:addSystem(MoveSystem()) -- order matters
  engine:addSystem(DrawSystem())
end

function love.update(dt)
  accumulator = accumulator + dt
  while accumulator > tickTime do
    engine:update(tickTime)
    accumulator = accumulator - tickTime
  end
end

function love.draw()
  engine:draw(accumulator)
end

function love.mousepressed(x, y)

end

function love.mousereleased()

end

function love.mousemoved(x, y, dx, dy)

end
