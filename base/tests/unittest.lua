package.path = package.path .. ";../?.lua"
base = require("base")

-- http://lua-users.org/wiki/TableUtils
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, ", " ) .. "}"
end

-- https://stackoverflow.com/questions/20325332/how-to-check-if-two-tablesobjects-have-the-same-value-in-lua
function equals(o1, o2, ignore_mt)
  if o1 == o2 then return true end
  local o1Type = type(o1)
  local o2Type = type(o2)
  if o1Type ~= o2Type then return false end
  if o1Type ~= 'table' then return false end

  if not ignore_mt then
    local mt1 = getmetatable(o1)
    if mt1 and mt1.__eq then
      --compare using built in method
      return o1 == o2
    end
  end

  local keySet = {}

  for key1, value1 in pairs(o1) do
    local value2 = o2[key1]
    if value2 == nil or equals(value1, value2, ignore_mt) == false then
      return false
    end
    keySet[key1] = true
  end

  for key2, _ in pairs(o2) do
    if not keySet[key2] then return false end
  end
  return true
end

function test(string, condition)
  local pass = " \27[31m[FAIL] "
  if condition then pass = " \27[32m[PASS] " end
  print(pass .. debug.getinfo(2).currentline .. ": " .. string)
end

function assert(condition)
  local pass = " \27[31m[FAIL] "
  if condition then pass = " \27[32m[PASS] " end
  print(pass .. debug.getinfo(2).currentline)
end

function assertEquals(a, b)
  local pass = " \27[31m[FAIL] "
  if equals(a, b) then pass = " \27[32m[PASS] " end

  local aString = a
  local bString = b
  if type(aString) == 'table' then aString = table.tostring(aString) end
  if type(bString) == 'table' then bString = table.tostring(bString) end

  print(pass .. debug.getinfo(2).currentline .. ": " ..
        aString .. " equals " .. bString)
end

function begin()
  local filename = debug.getinfo(2, 'S').source:match("^.+/(.+)$")
  if filename == nil then filename = "tests" end

  print("\27[34;1;4mRunning " .. filename .. "\27[0m")
end

function section(name)
  print("\27[0m-" .. name)
end

function finish()
  print("")
end
