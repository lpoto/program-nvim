local M = {}

local options = {
    size = 80,
    type = 0
}

M.filetypes = {}

function M.setup(opts)
    if not opts then
        return
    end
    if type(opts) ~= "table" then
        print("WARNING program.nvim - setup.errorlist")
        print("Expected a table value for 'errorlist")
        return
    end
    if opts.size then
        if opts.size < 10 or opts.size > 200 then
            print("WARNING program.nvim - setup.errorlist")
            print("'errorlist.size'" .. "can only be between 10 and 200")
        else
            options.size = opts.size
        end
    end
    if opts.type then
        if (opts.type ~= 0 and opts.type ~= 1) then
            print("WARNING program.nvim - setup.errorlist")
            print("'errorlist.type' can only be 0 or 1")
        else
            options.type = opts.type
        end
    end
    if opts.save then
        if type(opts.save) ~= "boolean" then
            print("WARNING program.nvim - setup.errorlist")
            print("'errorlist.save' needs to be a boolean")
        else
            options.save = opts.save
        end
    end
end

local create_window = function()
    if type == 1 then
        vim.cmd("new errorlist | resize" .. options.size)
    else
        vim.cmd("vertical new errorlist | vertical resize" .. options.size)
    end
end

local build_command = function(args)
    local cmd = ""
    args = vim.fn.split(args, ";") or {}
    local compiler_args = nil
    local execution_args = nil
    local args_count = 0
    for i, v in pairs(args) do
        args[i] = require("program.utils").expand(v)
        args_count = args_count + 1
    end
    if args_count > 1 then
        compiler_args = args[1]
        execution_args = args[2]
    elseif args_count == 1 then
        execution_args = args[1]
    end
    local ft = vim.o.filetype
    if not M.filetypes[ft] then
        ft = "*"
    end
    if M.filetypes[ft].interpreter then
        cmd = M.filetypes[ft].interpreter.exe
        if M.filetypes[ft].interpreter.args and next(M.filetypes[ft].interpreter.args) then
            local interpreter_args = {}
            for i, v in ipairs(M.filetypes[ft].interpreter.args) do
                interpreter_args[i] = require("program.utils").expand(v)
            end
            cmd = cmd .. " " .. table.concat(interpreter_args, " ")
        end
        if compiler_args then
            cmd = cmd .. " " .. compiler_args
        end
        if execution_args then
            cmd = cmd .. " " .. execution_args
        end
        if M.filetypes[ft].interpreter.end_args and next(M.filetypes[ft].interpreter.end_args) then
            local interpreter_end_args = {}
            for i, v in ipairs(M.filetypes[ft].interpreter.end_args) do
                interpreter_end_args[i] = require("program.utils").expand(v)
            end
            cmd = cmd .. " " .. table.concat(interpreter_end_args, " ")
        end
    elseif M.filetypes[ft].compiler then
        cmd = M.filetypes[ft].compiler.exe
        if M.filetypes[ft].compiler.args and next(M.filetypes[ft].compiler.args) then
            local comp_args = {}
            for i, v in ipairs(M.filetypes[ft].compiler.args) do
                comp_args[i] = require("program.utils").expand(v)
            end
            cmd = cmd .. " " .. table.concat(comp_args, " ")
        end
        if compiler_args then
            cmd = cmd .. " " .. compiler_args
        end
        if M.filetypes[ft].compiler.end_args and next(M.filetypes[ft].compiler.end_args) then
            local comp_end_args = {}
            for i, v in ipairs(M.filetypes[ft].compiler.end_args) do
                comp_end_args[i] = require("program.utils").expand(v)
            end
            cmd = cmd .. " " .. table.concat(comp_end_args, " ")
        end
        if M.filetypes[ft].execution then
            cmd = cmd .. "  && "
            if M.filetypes[ft].execution.exe then
                cmd = cmd .. " " .. M.filetypes[ft].execution.exe
            end
            if M.filetypes[ft].execution.args and next(M.filetypes[ft].execution.args) then
                local exec_args = {}
                for i, v in ipairs(M.filetypes[ft].execution.args) do
                    exec_args[i] = require("program.utils").expand(v)
                end
                cmd = cmd .. " " .. table.concat(exec_args, " ")
            end
        end
        if execution_args then
            cmd = cmd .. " " .. execution_args
        end
        if M.filetypes[ft].execution and M.filetypes[ft].execution.end_args and next(M.filetypes[ft].execution.end_args) then
            local exec_end_args = {}
            for i, v in ipairs(M.filetypes[ft].execution.end_args) do
                exec_end_args[i] = require("program.utils").expand(v)
            end
            cmd = cmd .. " " .. table.concat(exec_end_args, " ")
        end
    end
    return cmd
end

function M.run_program(args)
    local ft = vim.o.filetype
    if not M.filetypes[ft] then
        ft = "*"
    end
    if not M.filetypes[ft] or (not M.filetypes[ft].compiler and not M.filetypes[ft].interpreter) then
        print("No compilers or interpreters config found for filetype '" .. vim.o.filetype .. "'")
        return
    end
    vim.fn.execute("silent! bwipeout! " .. vim.fn.bufnr("_errorlist_"))
    local r, cmd = pcall(build_command, args)
    if not r then
        print("Could not run the program: " .. cmd)
        return
    end
    if cmd == "" then
        print("Could not run the program")
        return
    end
    if options.save then
        vim.cmd("silent! w")
    end
    local winnr = vim.fn.winnr()
    if not pcall(create_window) then
        print("Could not create a new window")
        return
    end
    local r2, e = pcall(vim.fn.termopen, "" .. cmd .. "", {detach = 0})
    if not r2 then
        print("Could not run the program: " .. e)
        return
    end
    vim.api.nvim_buf_set_name(vim.fn.bufnr(""), "_errorlist_")
    vim.o.filetype = "errorlist"
    vim.o.winfixwidth = true
    vim.cmd("normal G")
    vim.fn.execute(winnr .. " wincmd p")
    local txt = ""
    for _, v in ipairs(vim.fn.split(cmd)) do
        if string.len(v) > 20 and string.find(v, "/") then
            v = vim.fn.split(v, "/")
            v = v[#v]
        end
        if txt == "" and v ~= "" then
            txt = v
        elseif v ~= "" then
            txt = txt .. " " .. v
        end
    end
    print(txt)
end

function M.toggle_errorlist()
    local bufnr = vim.fn.bufnr("_errorlist_")
    if bufnr == -1 then
        print("The program is not running")
        return
    end
    local winid = vim.fn.bufwinid(bufnr)
    local winnr = vim.fn.winnr()
    if vim.fn.win_gotoid(winid) == 1 then
        vim.fn.execute("hide")
        vim.fn.execute(winnr .. " wincmd p")
        return
    end
    M.open_existing_errorlist(winnr, bufnr)
end

function M.open_existing_errorlist(winnr, bufnr)
    if not pcall(create_window) then
        print("Could not create a new window")
        return
    end
    if not pcall(vim.fn.execute, "buffer " .. bufnr) then
        return
    end
    vim.fn.execute("setlocal winfixwidth")
    vim.fn.execute("normal G")
    if not pcall(vim.fn.execute, winnr .. " wincmd p") then
        return
    end
end

function M.get_opts()
    return options
end

return M
