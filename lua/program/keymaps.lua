local M = {}

function M.setup(opts)
	if not opts then return end
	if type(opts) ~= "table" then
		print("WARNING program.nvim - setup.keymaps")
		print("'keymaps' needs to be a table")
	else
		for fun, v in pairs(opts) do
			if type(v) ~= "table" then
				print("WARNING program.nvim - setup.keymaps")
				print("'"..fun.."' needs to be a table")
				break
			end
			if not v.key or not v.modes then
				goto continue
			end
			if type(v.modes) ~= "table" then
				print("WARNING program.nvim - setup.keymaps")
				print("'"..fun..".modes' needs to be a table")
				goto continue
			end
			for _, mode in pairs(v.modes) do
				local cmd = "<cmd>lua require('program')."..fun.."()<CR>"
				if mode == "t" and cmd == "terminal_toggle" then
					cmd = "<C-\\><C-n>"..cmd
				end
				vim.api.nvim_set_keymap(
					mode,
					v.key,
					cmd,
					v.args or {}
				)
			end
			::continue::
		end
	end
end

return M
