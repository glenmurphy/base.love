local folder = (...):match("(.-)[^%/%.]+$")

base = {}
base.class = require(folder .. 'class')
base.componentClass = require(folder .. "component")
base.systemClass = require(folder .. "system")
base.Entity = require(folder .. "entity")
base.Engine = require(folder .. "engine")
base.Camera = require(folder .. "camera")
return base
