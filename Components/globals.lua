--Scope: 1
local move = table.move
local insert = table.insert
local remove = table.remove
local function setmeta() end --see Source file for implementation

--Scope: function setmeta (2)
local function getIndex(num, pos)
	return type(num) == 'number' and (num > 0 and num or num + #tab + 1) or error('bad argument #' .. pos .. '(number expected, got ' .. type(num) .. ')')
end
local function get(self, num)
	return self[getIndex(num)]
end
local function concat(self, sep)
	local components = {}
	for i,v in ipairs(self) do
		components[#components + 1] = tostring(v)
	end
	return table.concat(components, sep or '')
end