local M = {}

function M.setup(opts)
	if not opts then return end
	if type(opts) ~= "table" then
		print("WARNING program.nvim - setup.filetypes")
		print("Expected a table value for 'filetypes")
		return
	end
	local run = require('program.run_program')
	local not_formating = false
	for filetype, v in pairs(opts) do
		if type(v) ~= 'table' then
			print("WARNING program.nvim - setup.filetypes")
			print("Expected a table value for '"..filetype.."'")
			return
		end
		if not run.filetypes[filetype] then
			run.filetypes[filetype] = {}
		end
		if v.compiler and not v.execution then
			run.filetypes[filetype].execution = nil
		end
		for option, v2 in pairs(v) do
			if option == 'compiler' or
				option == 'interpreter' or
				option == 'execution' then
				if type(v2) ~= 'table' then
					print("WARNING program.nvim - setup.filetypes")
					print("Expected a table value for '"
						..filetype.."."..option.."'")
					goto continue
				end
				if option ~= "execution" and v2.exe == nil then
					print("WARNING program.nvim - setup.filetypes")
					print("Missing 'exe' table key for '"
						..filetype.."."..option.."'")
					goto continue
				end
				run.filetypes[filetype][option] = v2
			end
			if option == 'formater' then
				if not_formating then goto continue end
				if type(v2) ~= 'table' then
					print("WARNING program.nvim - setup.filetypes")
					print("Expected a table value for '"
						..filetype.."."..option.."'")
					goto continue
				end
				for t, v3 in pairs(v2) do
					if t == 'enabled' then
						if type(v3) ~= "table" then
							print("'"..filetype
								..".formater.enabled' needs to be a table")
						goto continue2
						end
						vim.g['neoformat_enabled_'..filetype] = v3
					elseif t == 'save' then
						if type(v3) ~= "boolean" then
							print("'"..filetype
								..".formater.save' needs to be a boolean")
						goto continue2
						end
						run.filetypes[filetype].save = v3
					else
						if type(v3) ~= "table" then
							print("'"..filetype
								..".formater."..t.."' needs to be a table")
						goto continue2
						end
						vim.g['neoformat_'..filetype.."_"..t] = v3
					end
					::continue2::
				end
			end
		end
		::continue::
	end
end

return M
