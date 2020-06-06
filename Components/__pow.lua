--See globals.lua for function references

local __pow = function(self, tab)
	if type(tab) == 'table' then
		return setmeta(move(self, getIndex(self, tab[1], 1), getIndex(self, tab[2] or #self, 2), 1, {}))
	else
		error('bad argument #2 (table expected, got ' .. type(tab) .. ')', 2)
	end
end