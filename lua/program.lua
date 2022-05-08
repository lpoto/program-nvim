--=============================================================================
-------------------------------------------------------------------------------
--																		PROGRAM
--=============================================================================
-- Asynchronously run programs
-- toggling terminal
--_____________________________________________________________________________

local M = {}

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
end

local functions = {
	'run_program(args)',
	'toggle_terminal()',
	'toggle_errorlist()',
    'get_filetypes_config()',
    'get_errorlist_config()',
    'get_terminal_config()',
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

function M.get_errorlist_config()
    print(require('program.run_program').get_opts())
end

function M.get_terminal_config()
    print(require('program.terminal').get_opts())
end

function M.get_filetypes_config()
    print(require('program.run_program').get_filetypes_opts())
end

return M
