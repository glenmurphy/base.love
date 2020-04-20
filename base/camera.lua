local folder = (...):match("(.-)[^%/%.]+$")
local class = require(folder .. "class")

local Camera = class()

Camera.FIT = 1
Camera.COVER = 2

function Camera:init(width, height)
  if width == nil then
    width, height = 800, 600
  end

  self.origin = {x = width / 2, y = height / 2}
  self.idealSize = {w = width, h = height}
  self.size = {w = width, h = height}
  self.screen = {w = width, h = height}
  self.style = Camera.FIT -- "Cover" | "Fit"
end

function Camera:setIdealSize(ideal)
  self.idealSize.w, self.idealSize.h = ideal.w, ideal.h
  self:updateSize()
end

function Camera:setScreenSize(screen)
  self.screen.w, self.screen.h = screen.w, screen.h
  self:updateSize()
end

function Camera:setOrigin(origin)
  self.origin.x, self.origin.y = origin.x, origin.y
end

function Camera:setStyle(style)
  if (style ~= Camera.FIT and style ~= Camera.COVER) then error() end

  self.style = style
  self:updateSize()
end

function Camera:updateSize()
  local ratio = self.screen.h / self.screen.w;
  local intendedRatio = self.idealSize.h / self.idealSize.w;

  if (self.style == Camera.FIT and ratio >= intendedRatio) or
     (self.style == Camera.COVER and ratio <= intendedRatio) then
    self.size.w = self.idealSize.w;
    self.size.h = self.idealSize.w * ratio;
  else
    self.size.w = self.idealSize.h / ratio;
    self.size.h = self.idealSize.h;
  end
end

function Camera:scaleFactor()
  if self.style == Camera.FIT then
    return math.max(self.screen.w / self.size.w, self.screen.h / self.size.h)
  else
    return math.min(self.screen.w / self.size.w, self.screen.h / self.size.h)
  end
end

-- Given a set of screen coordinates, translate them into world coordinates
function Camera:screenToWorld(screen)
  -- Figure out percentage of screen
  local x = screen.x / self.screen.w;
  local y = screen.y / self.screen.h;

  -- Apply percentage to view size
  --  center          to topleft corner   apply percentage
  x = self.origin.x - (self.size.w / 2) + self.size.w * x;
  y = self.origin.y + (self.size.h / 2) - self.size.h * y;

  return { x = x, y = y}
end

function Camera:worldToScreen(world)
  -- This is  a reversal of screenToWorld, so any bugs in that will show up here
  return {
    x = (world.x - self.origin.x + (self.size.w / 2)) *
        self.screen.w / self.size.w,
    y = (world.y - self.origin.y - (self.size.h / 2)) *
        self.screen.h / -self.size.h
  }
end

return Camera
