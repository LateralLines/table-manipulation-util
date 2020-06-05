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
		end