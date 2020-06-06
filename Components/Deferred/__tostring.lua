local function concat(self, sep)
	local components = {}
	for i,v in ipairs(self) do
		components[#components + 1] = tostring(v)
	end
	return table.concat(components, sep or '')
end
__tostring = concat