local move = table.move
local insert = table.insert
local remove = table.remove

local function setmeta(tab)
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
	return setmetatable(tab, {
		__call = function(self, ...)
			local args = table.pack(...)
			local numArgs = select('#', ...)
			if numArgs > 0 then
				local first = args[1]
				local dType = type(first)
				if dType == 'table' then
					if numArgs > 1 then
						if numArgs > 2 then
							if args[5] == true then
								local second, third, fourth = getIndex(args[2], 2), getIndex(args[3], 3), getIndex(args[4], 4)
								local half2 = move(self, fourth, #self, 1, {})
								move(half2, second, #half2, fourth + third - second + 1, move(first, second, third, fourth, self))
							elseif numArgs == 3 then
								move(first, getIndex(args[2], 2), getIndex(args[3], 3), 1, self)
							else
								move(first, getIndex(args[2], 2), getIndex(args[3], 3), getIndex(args[4], 4), self)
							end
						else
							insert(self, getIndex(args[2], 2), first)
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
							if args[3] then
								for i,v in pairs(second) do
									self[getIndex(v)] = nil
								end
							else
								for i,v in pairs(second) do
									remove(self, getIndex(v) - i + 1)
								end
							end
						else
							error('bad argument #2 (number or table expected)')
						end
					else
						self[#self] = nil
					end
				else
					if numArgs > 1 then
						local second = args[2]
						local dType = type(second)
						if dType == 'number' then
							insert(self, getIndex(second), first)
						elseif dType == 'table' then
							if args[3] then
								for i,v in pairs(second) do
									self[getIndex(v)] = first
								end
							else
								for i,v in pairs(second) do
									insert(self, getIndex(v), first)
								end
							end
						else	
							error('bad argument #2 (number or table expected)')
						end
					else
						self[#self + 1] = first
					end	
				end
				return self
			else
				local newTab = {}
				for i,v in pairs(self) do
					newTab[i] = v
				end	
				return setmeta(newTab)
			end
		end,
		__add = get,
		__sub = get,
		__mul = function(self, tab)
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
				error('bad argument #2 (table expected, got ' .. type(tab) .. ')')
			end
		end,
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
				error('bad argument #2 (table expected, got ' .. type(tab) .. ')')
			end
		end,
		__mod = function(self, tab)
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
				error('bad argument #2 (table expected, got ' .. type(tab) .. ')')
			end
		end,
		__pow = function(self, tab)
			if type(tab) == 'table' then
				return setmeta(move(self, getIndex(tab[1], 1), getIndex(tab[2] or #self, 2), 1, {}))
			else
				error('bad argument #2 (table expected, got ' .. type(tab) .. ')')
			end
		end,
		__unm = function(self)
			local target = table.create(#self)
			for i=1,#self do
				target[i] = self[#self - i + 1]
			end
			return setmeta(target)
		end,
		__concat = concat,
		__tostring = concat
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
			return setmeta(table.create(...))
		end
	else
		return setmeta{}
	end
end