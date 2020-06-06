local function get(self, val)
	if type(val) == 'number' then
		return self[(val > 0 and val or val + #self + 1)]
	else
		return self[val]
	end		
end
__add = get