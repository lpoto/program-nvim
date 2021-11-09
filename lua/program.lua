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

M.setup_loaded = false

function M.setup(opts)
	if M.setup_loaded then return end
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
	M.setup_loaded = true
end

local functions = {
	'run_program(args)',
	'toggle_terminal()',
	'toggle_errorlist()',
	'local_config()',
	'source_local_config()',
	'get_root()'
}

function M.functions()
	print(table.concat(functions, ', '))
end

function M.run_program(args)
	require('program.run_program').run_program(args)
end

function M.toggle_errorlist()
	require('program.run_program').toggle_errorlist()
end

function M.toggle_terminal()
	require('program.terminal').toggle_terminal()
end

function M.source_local_config()
	local x = M.setup_loaded
	M.setup_loaded = false
	require('program.utils').source_lua_file(
		require('program.utils').config_file()
	)
	if not M.setup_loaded then M.setup_loaded = x end
end

function M.local_config()
	require('program.utils').local_config()
end

function M.get_root()
	require('program.utils').getcwd()
end

return M
