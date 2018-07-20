-- switch.lua

-- ref :: http://lua-users.org/wiki/SwitchStatement

-- Switch returns function instead of table
function SWITCH(case)
  return function(codetable)
    local f
    f = codetable[case] or codetable.default
    if f then
      if type(f)=="function" then
        return f(case)
      else
        error("case "..tostring(case).." not a function")
      end
    end
  end
end

--[[
--	example
for case = 1,4 do
  SWITCH(case) {
    [1] = function() print("one") end,
    [2] = print,
    default = function(x) print("default",x) end,
  }
end
]]

-- Case method
function SWITCH_CASE(t)
  t.case = function (self,x)
    local f=self[x] or self.default
    if f then
      if type(f)=="function" then
        f(x,self)
      else
        error("case "..tostring(x).." not a function")
      end
    end
  end
  return t
end

--[[
--	example

a = SWITCH_CASE {
  [1] = function (x) print(x,10) end,
  [2] = function (x) print(x,20) end,
  default = function (x) print(x,0) end,
}

a:case(2)  -- ie. call case 2 
a:case(9)
]]


-- Caseof method table
function SWITCH_CASEOF(c)
  local swtbl = {
    casevar = c,
    caseof = function (self, code)
      local f
      if (self.casevar) then
        f = code[self.casevar] or code.default
      else
        f = code.missing or code.default
      end
      if f then
        if type(f)=="function" then
          return f(self.casevar,self)
        else
          error("case "..tostring(self.casevar).." not a function")
        end
      end
    end
  }
  return swtbl
end

--[[
--	example
c = 1
SWITCH_CASEOF(c) : caseof {
    [1]   = function (x) print(x,"one") end,
    [2]   = function (x) print(x,"two") end,
    [3]   = 12345, -- this is an invalid case stmt
  default = function (x) print(x,"default") end,
  missing = function (x) print(x,"missing") end,
}

-- also test the return value
-- sort of like the way C's ternary "?" is often used
-- but perhaps more like LISP's "cond"
--
print("expect to see 468:  ".. 123 +
  SWITCH_CASEOF(2):caseof{
    [1] = function(x) return 234 end,
    [2] = function(x) return 345 end
  })
]]

