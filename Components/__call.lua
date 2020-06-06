--See globals.lua for function references

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