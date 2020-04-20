-- example component:
-- local Position = base.componentClass("Position")
--
-- function Position:init(x, y)
--   self.x = x
--   self.y = y
-- end
--
-- return Position

return function(name, values)
  local c = base.class()
  c.name = name
  return c
end
