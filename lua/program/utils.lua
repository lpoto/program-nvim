local M = {}

local exists = function(path)
	return vim.fn.filereadable(path) == 1 or vim.fn.isdirectory(path) == 1
end

function M.local_config()
	local file = M.config_file()
	if vim.fn.isdirectory(vim.fn.stdpath('config').."/.projects") ~= 1 then
		vim.cmd("!mkdir "..vim.fn.stdpath('config').."/.projects")
	end
	if vim.fn.filereadable(file) == 1 then
		vim.cmd("find "..file:gsub('%%', "\\%%"))
	else
		vim.cmd("edit "..file:gsub('%%', "\\%%").."")
	end
	local project_name = vim.fn.split(M.getcwd(), "/")
	project_name = project_name[#project_name]
	print("This is a local config file for project '"..project_name.."'")
end

function M.source_lua_file(file)
	if vim.fn.filereadable(file) == 1 then
		if not string.find(file, '\\%%') then
			file = file:gsub("%%", "\\%%")
		end
		vim.cmd("luafile "..file)
		local project_name = vim.fn.split(M.getcwd(), "/")
		project_name = project_name[#project_name]
		print("Sourced local config for project '"..project_name.."'")
	end
end

function M.config_file()
	local file
	if vim.fn.expand("%:p:h") == vim.fn.stdpath('config').."/.projects" then
		file = vim.fn.expand("%:p:t")
	else
		file = M.getcwd()..".lua"
	end
	file = file:gsub("/", "%%")
	return vim.fn.stdpath('config').."/.projects/"..file
end

function M.getcwd()
	local max_idx = 50
	local idx = 0
	local path = vim.fn.getcwd()
	local temp_path = path
	while string.len(temp_path) > 0 do
		if idx == max_idx then
			break
		end
		idx = idx + 1
		if vim.fn.isdirectory(temp_path.."/.git") == 1 then
			return temp_path
		end
		temp_path = string.gsub(temp_path, "/(.%w+)$", "")
	end
	return path
end

function M.find_path(opts)
	setmetatable(opts,
		{
			_index={
				stop=nil,
				max_depth=5,
				must_include=nil
		}
	})
	local name =opts[1] or opts.name
	local stop = opts[2] or opts.stop
	local max_depth = opts[3] or opts.max_depth
	local must_include = opts[4] or opts.must_include
	if not max_depth then
		max_depth = 5
	elseif max_depth > 50 then
		max_depth = 50
	end
	if not name then return '' end
	local path = M.getcwd()
	local index = 1
	while string.len(path) > 0 do
		local temp_path = path
		if string.len(name) > 0 then temp_path = temp_path.."/"..name end
		if (not must_include or exists(path.."/"..must_include))
			and exists(temp_path) then
			return temp_path
		end
		if (stop and exists(path.."/"..stop)) or index == max_depth then
			return ""
		end
		path = string.gsub(path, "/(%w+)$", "")
		index = index + 1
	end
	return ""
end

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
