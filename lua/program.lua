--=============================================================================
-------------------------------------------------------------------------------
--																		PROGRAM
--=============================================================================
-- Asynchronously run programs
-- formating with neoformat - (https://github.com/sbdchd/neoformat)
-- toggling terminal
-- project local configs are saved in ..../.config/nvim/.projects/
--_____________________________________________________________________________

local M = {}

local filetypes = {}
local format_unspecified = true

function M.setup(opts)
	local r, e = pcall(require('program.terminal').setup, opts.terminal)
	if not r then
		print("ERROR program.nvim - setup.terminal")
		print(e)
	end
	r, e = pcall(require('program.run_program').setup, opts.errorlist)
	if not r then
		print("ERROR program.nvim - setup.run_program")
		print(e)
	end
	r, e = pcall(require('program.filetypes').setup, opts.filetypes)
	if not r then
		print("ERROR program.nvim - setup.filetypes")
		print(e)
	end
	r, e = pcall(require('program.keymaps').setup, opts.keymaps)
	if not r then
		print("ERROR program.nvim - setup.keymaps")
		print(e)
	end
	if opts.format_unspecified then
		if type(opts.format_unspecified) ~= "boolean" then
			print("WARNING program.nvim - setup.format_unspecified")
			print("'format_unspecified' needs to be a boolean")
		else
			format_unspecified = opts.format_unspecified
		end

	end
end

-- format if no formatter specified
if format_unspecified then
	vim.g['neoformat_basic_format_align'] = 1
	vim.g['neoformat_basic_format_trim'] = 1
end

function M.format()
	local ft = vim.o.filetype
	if vim.fn.exists(':Neoformat') == 0 then
		print('neoformat not installed')
		return
	end
	if filetypes[ft] and filetypes[ft].formater and
		filetypes[ft].formater.save then
		vim.cmd("Neoformat | silent w")
	else
		vim.cmd("Neoformat")
	end
end

local functions = {
	'run_program(args)',
	'toggle_terminal()',
	'toggle_errorlist()',
	'format()',
	'local_config()',
	'source_local_config()'
}

function M.functions()
	print(table.concat(functions, ', '))
end

function M.run_program(args)
	require('program.run_program').run_program(args)
end

function M.toggle_terminal()
	require('program.terminal').terminal_toggle()
end

function M.source_local_config()
	require('program.utils').source_lua_file(
		require('program.utils').config_file()
	)
end

function M.local_config()
	require('program.utils').local_config()
end

return M
