--Scope: 1
local move = table.move
local insert = table.insert
local remove = table.remove
local create = table.create
local function setmeta() end --see Source file for implementation

local function getIndex(self, num, pos)
	return type(num) == 'number' and (num > 0 and num or num + #self + 1) or error('bad argument #' .. pos .. '(number expected, got ' .. type(num) .. ')', 2)
end
local function get(self, val)
	if type(val) == 'number' then
		return self[(val > 0 and val or val + #self + 1)]
	else
		return self[val]
	end		
end
local function concat(self, sep)
	local components = {}
		for i,v in ipairs(self) do
		components[#components + 1] = tostring(v)
	end
	return table.concat(components, sep or '')
end
local function fill(self, first, second, third)
	local dType = type(second)
	if dType == 'number' then
		insert(self, getIndex(self, second), first)
	elseif dType == 'table' then
		if next(second) then
			if third then
				for i,v in pairs(second) do
					self[getIndex(self, v)] = first
				end
			else
				for i,v in pairs(second) do
					insert(self, getIndex(self, v), first)
				end
			end
		else
			local length = #self 
			move(create(length, first), 1, length, 1, self)
		end
	else	
		error('bad argument #2 (number or table expected)', 2)
	end
end