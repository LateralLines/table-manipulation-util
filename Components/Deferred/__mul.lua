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