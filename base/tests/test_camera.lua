require('unittest')

begin()

section("Screen size") ---------------------------------------------------------
local c = base.Camera()
assertEquals(c.size.w, 800)

c:setIdealSize({w = 500, h = 700})
c:setScreenSize({w = 1000, h = 2000})

assertEquals(c.size.w, 500);
assertEquals(c.size.h, 1000);

c:setScreenSize({w = 1000, h = 1000})
assertEquals(c.size.w, 700)
assertEquals(c.size.h, 700)
assertEquals(c.idealSize.w, 500)
assertEquals(c.idealSize.h, 700)

c:setStyle(base.Camera.COVER)
assertEquals(c.size.w, 500)
assertEquals(c.size.h, 500)

c:setScreenSize({w = 1000, h = 2000})
assertEquals(c.size.w, 350)
assertEquals(c.size.h, 700)
assertEquals(c.idealSize.w, 500)
assertEquals(c.idealSize.h, 700)

section("Scale factor") --------------------------------------------------------
local c = base.Camera(500, 1000)

c:setScreenSize({w = 1500, h = 2000})
assertEquals(c:scaleFactor(), 2)

c:setScreenSize({w = 1000, h = 1500})
assertEquals(c:scaleFactor(), 1.5)

c:setScreenSize({w = 600, h = 1500})
assertEquals(c:scaleFactor(), 1.2)

c:setStyle(base.Camera.COVER)
c:setScreenSize({w = 1000, h = 1500})
assertEquals(c:scaleFactor(), 2)

c:setScreenSize({w = 600, h = 1500})
assertEquals(c:scaleFactor(), 1.5)

section("screenToWorld") -------------------------------------------------------
local c = base.Camera(500, 1000)

-- test 1:1
c:setScreenSize({w = 500, h = 1000})
assertEquals(c:screenToWorld({x = 0, y = 0}), {x = 0, y = 1000})
assertEquals(c:screenToWorld({x = 250, y = 500}), {x = 250, y = 500})
assertEquals(c:screenToWorld({x = 400, y = 900}), {x = 400, y = 100})

-- test 1:1.5
c:setScreenSize({w = 750, h = 1500})
assertEquals(c:screenToWorld({x = 0, y = 0}), {x = 0, y = 1000})
assertEquals(c:screenToWorld({x = 375, y = 750}), {x = 250, y = 500})
assertEquals(c:screenToWorld({x = 600, y = 1350}), {x = 400, y = 100})

-- test different aspect ratio
c:setScreenSize({w = 500, h = 1500})
assertEquals(c:screenToWorld({x = 0, y = 0}), {x = 0, y = 1250})
assertEquals(c:screenToWorld({x = 250, y = 750}), {x = 250, y = 500})
assertEquals(c:screenToWorld({x = 400, y = 1350}), {x = 400, y = -100})

section("worldToScreen") -------------------------------------------------------
local c = base.Camera(500, 1000)

local input = {x = 37, y = -15}
local intermediate = c:screenToWorld(input)
local output = c:worldToScreen(intermediate)
assertEquals(input, output)

local input = {x = -5001, y = 593}
local intermediate = c:screenToWorld(input)
local output = c:worldToScreen(intermediate)
assertEquals(input, output)

finish()
