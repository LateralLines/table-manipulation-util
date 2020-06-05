--See globals.lua for function references

__pow = function(self, tab)
	if type(tab) == 'table' then
		return setmeta(move(self, getIndex(tab[1], 1), getIndex(tab[2] or #self, 2), 1, {}))
	else
		error('bad argument #2 (table expected, got ' .. type(tab) .. ')')
	end
end