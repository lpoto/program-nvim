local M = {}

function M.expand(args)
	args = vim.fn.split(args, ' ')
	for i, w in pairs(args) do
		w = vim.fn.split(w, '/')
		for k, v in pairs(w) do
			local parts = vim.fn.split(v, '\\.')
			for k2, v2 in pairs(parts) do
				if string == '%' or
					string.sub(v2, 1, 3) == '%:p' or
					string.sub(v2, 1, 3) == '%:h' or
					string.sub(v2, 1, 3) == '%:t' or
					string.sub(v2, 1, 3) == '%:r' or
					string.sub(v2, 1, 3) == '%:e'then
                    if string.sub(v2, -2) ==  ":u" then
                        parts[k2] = string.upper(
                        vim.fn.expand(string.sub(v2, 1, -3)))
                    end
					parts[k2] = vim.fn.expand(v2)
				else
					parts[k2] = v2
				end
			end
			w[k] = table.concat(parts, '.')
		end
		w = table.concat(w, '/')
		if string.sub(w, 1, 4) == "home" then
			w = "/"..w
		end
		args[i] = w
	end
	return table.concat(args, ' ')
end

return M
