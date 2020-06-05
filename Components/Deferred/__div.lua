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
end