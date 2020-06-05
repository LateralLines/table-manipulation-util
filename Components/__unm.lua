--See globals.lua for function references

__unm = function(self)
	local target = table.create(#self)
	for i=1,#self do
		target[i] = self[#self - i + 1]
	end
	return setmeta(target)
end