--See globals.lua for function references

local __unm = function(self)
	local length = #self
	local target = create(length)
	for i=1,length do
		target[i] = self[#self - i + 1]
	end
	return setmeta(target)
end