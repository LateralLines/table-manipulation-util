local move = table.move
local insert = table.insert
local remove = table.remove
local create = table.create
local setmeta

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

local __call = function(self, ...)
	local args = table.pack(...)
	local numArgs = select('#', ...)
	if numArgs > 0 then
		local first = args[1]
		local dType = type(first)
			if dType == 'table' then
			if numArgs > 1 then
				if numArgs > 2 then
					if args[5] == true then
						local second, third, fourth = getIndex(first, args[2], 2), getIndex(first, args[3], 3), getIndex(self, args[4], 4)
						local half2 = move(self, fourth, #self, 1, {})
						move(half2, second, #half2, fourth + third - second + 1, move(first, second, third, fourth, self))
					elseif numArgs == 3 then
						move(first, getIndex(first, args[2], 2), getIndex(first, args[3], 3), 1, self)
					else
						move(first, getIndex(first, args[2], 2), getIndex(first, args[3], 3), getIndex(self, args[4], 4), self)
					end
				else
					local second = args[2]
					if type(second) == 'table' then
						fill(self, first, second, args[3])
					else
						insert(self, getIndex(self, args[2], 2), first)
					end
				end
			else
				if next(first) then
					for i,v in pairs(first) do
						rawset(self, i, v)
					end
				else
					local target = {}
					local tabStack1, tabStack2, iStack = {self}, {target}, {}
					local currentTab1, currentTab2, i = self, target, 0
					local v
					while currentTab1 do
						i = i + 1
						v = currentTab1[i]
						while v and type(v) ~= 'table' do
							currentTab2[i] = v
							i = i + 1
							v = currentTab1[i]
						end
						if v then
							local newTab = {}
							currentTab2[i] = newTab
							tabStack1[#tabStack1 + 1], tabStack2[#tabStack2 + 1] = v, newTab
							iStack[#iStack + 1] = i
							currentTab1, currentTab2, i = v, newTab, 0
						else
							tabStack1[#tabStack1], tabStack2[#tabStack2]  = nil, nil
							i = iStack[#iStack]
							iStack[#iStack] = nil
							currentTab1, currentTab2 = tabStack1[#tabStack1], tabStack2[#tabStack2] 
						end
					end
					return setmeta(target)
				end
			end
		elseif dType == 'nil' then
			if numArgs > 1 then
				local second = args[2]
				local dType0 = type(second) 
				if dType0 == 'number' then
					remove(self, second)
				elseif dType0 == 'table' then
				if next(second) then
						if args[3] then
							for i,v in pairs(second) do
								self[getIndex(self, v)] = nil
							end
						else
							for i,v in pairs(second) do
								remove(self, getIndex(self, v) - i + 1)
							end
						end
					else
						for i,v in pairs(self) do
							self[i] = nil
						end
					end
				else
					error('bad argument #2 (number or table expected)', 2)
				end
			else
				self[#self] = nil
			end
		else
			if numArgs > 1 then
				fill(self, first, args[2], args[3])
			else
				insert(self, first)
			end
		end
		return self
	else
		local newTab = create(#self)
		for i,v in pairs(self) do
			newTab[i] = v
		end	
		return setmeta(newTab)
	end
end
local __mul = function(self, tab)
	if type(tab) == 'table' then
		local diff = {}
		local map1, map2 = {}, {}
		for i,v in pairs(self) do
			if map1[v] then
				map1[v] = map1[v] + 1
			else
				map1[v] = 1	
			end
		end
		for i,v in pairs(tab) do
			if map2[v] then
				map2[v] = map2[v] + 1
			else
				map2[v] = 1	
			end	
		end
		for i,v in pairs(map1) do
			local m2 = map2[i]
			for i0=1, v do
				if map2[i] > 0 then
						map2[i] = map2[i] - 1
					map1[i] = map1[i] - 1
				else
					diff[#diff + 1] = {value = i, count = -i0}
					break
				end
			end
			if m2 > 0 then
				diff[#diff + 1] = {value = i, count = m2}
			end
		end
		return setmeta(diff)
	else
		error('bad argument #2 (table expected, got ' .. type(tab) .. ')', 2)
	end
end
__div = function(self, tab)
	if type(tab) == 'table' then
		local diff = {}
		for i,v in pairs(self) do
			if v ~= tab[i] then
				diff[#diff + 1] = i
			end 
		end
		return setmeta(diff)
	else
		error('bad argument #2 (table expected, got ' .. type(tab) .. ')', 2)
	end
end
local __mod = function(self, tab)
	if type(tab) == 'table' then
		local match = {}
		if tab[1] then
			if tab[2] then
				for i,v in pairs(self) do
					if v == tab[1] then
						match[#match + 1] = i
					end
				end
			else
				for i,v in pairs(self) do
					if v == tab[1] then
						match[#match + 1] = i
						break
					end
				end
			end
		end
		return setmeta(match)
	else
		error('bad argument #2 (table expected, got ' .. type(tab) .. ')', 2)
	end
end
local __pow = function(self, tab)
	if type(tab) == 'table' then
		return setmeta(move(self, getIndex(self, tab[1], 1), getIndex(self, tab[2] or #self, 2), 1, {}))
	else
		error('bad argument #2 (table expected, got ' .. type(tab) .. ')', 2)
	end
end
local __unm = function(self)
	local length = #self
	local target = create(length)
	for i=1,length do
		target[i] = self[#self - i + 1]
	end
	return setmeta(target)
end

setmeta = function(tab)
	return setmetatable(tab, {
		__call = __call,
		__add = get,
		__sub = get,
		__mul = __mul,
		__div = __div,
		__mod = __mod,
		__pow = __pow,
		__unm = __unm,
		__concat = concat,
		--__tostring = concat
	})
end

return function(...)
	local args = table.pack(...)
	local numArgs = select('#', ...)
	if numArgs > 0 then
		local first = args[1]
		local dType = type(first)
		if dType == 'table' then
			return not args[2] and setmeta(first) or setmetatable(first, nil)
		elseif dType == 'number' then
			return setmeta(create(...))
		end
	else
		return setmeta{}
	end
end