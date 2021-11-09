local M = {}

local options = {
	size = 80,
	type = 0
}

function M.setup(opts)
	if not opts then return end
	if type(opts) ~= "table" then
		print("WARNING program.nvim - setup.terminal")
		print("'terminal' needs to be a table")
		return
	end
	if opts.size  then
		if opts.size < 10 or opts.size > 200 then
			print("WARNING program.nvim - setup.terminal")
			print("'terminal.size'"
				.."can only be between 10 and 200")
		else
			options.size = opts.size
		end
	end
	if opts.type then
		if (opts.type ~= 0 and opts.type ~= 1) then
			print("WARNING program.nvim - setup.terminal")
			print("'terminal.type' can only be 0 or 1")
		else
			options.type = opts.type
		end
	end
end

local create_window = function()
	if options.type == 1 then
		vim.cmd("new terminal | resize"..options.size)
	else
		vim.cmd("vertical new terminal | vertical resize"
		..options.size)
	end
end

function M.toggle_terminal()
	local term_buffers = vim.fn.split(vim.fn.execute('buffers R'), '\n')
	if term_buffers == nil or next(term_buffers) == nil then
		create_window();
		vim.fn.termopen(vim.o.shell, {detach = 0})
	else
		local buf_nr = tonumber(vim.fn.split(term_buffers[1], " ")[1])
		local win_nr = vim.fn.bufwinid(buf_nr)
		if vim.fn.win_gotoid(win_nr) == 1 then
			vim.cmd("hide")
			return
		else
			create_window();
			vim.cmd("buffer "..buf_nr)
		end
	end
	vim.cmd("startinsert!")
end


return M
