--=============================================================================
-------------------------------------------------------------------------------
--																		PROGRAM
--=============================================================================
-- Asynchronously run programs
-- toggling terminal
--_____________________________________________________________________________

local M = {}

function M.setup(opts)
    local allowed_keys = {
        filetypes = true,
        filetype = true,
        terminal = true,
        errorlist = true
    }
    for k in pairs(opts) do
        if not allowed_keys[k] then
            local e = "WARN program.nvim - setup: "
            print(e .. "Unrecognized setup table key: '" .. k .. "'.")
        end
    end
    if (opts.filetype and not opts.filetypes) then
        opts.filetypes = opts.filetype
        opts.filetype = nil
    end
    local r, e = pcall(require("program.terminal").setup, opts.terminal)
    if not r then
        local v = "ERROR program.nvim - setup.terminal: "
        print(v .. e)
    end
    r, e = pcall(require("program.run_program").setup, opts.errorlist)
    if not r then
        local v = "ERROR program.nvim - setup.run_program: "
        print(v .. e)
    end
    r, e = pcall(require("program.filetypes").setup, opts.filetypes)
    if not r then
        local v = "ERROR program.nvim - setup.filetypes: "
        print(v .. e)
    end
end

local functions = {
    "run_program(args)",
    "toggle_terminal()",
    "toggle_errorlist()",
    "get_filetypes_config()",
    "get_errorlist_config()",
    "get_terminal_config()"
}

function M.functions()
    print(table.concat(functions, ", "))
end

function M.run_program(args)
    require("program.run_program").run_program(args)
end

function M.toggle_errorlist()
    require("program.run_program").toggle_errorlist()
end

function M.toggle_terminal()
    require("program.terminal").toggle_terminal()
end

function M.get_errorlist_config()
    print(require("program.utils").dump(require("program.run_program").get_opts()))
end

function M.get_terminal_config()
    print(require("program.utils").dump(require("program.terminal").get_opts()))
end

function M.get_filetypes_config()
    print(require("program.utils").dump(require("program.run_program").filetypes))
end

function M.get_config()
    print(
        require("program.utils").dump(
            {
                terminal = require("program.terminal").get_opts(),
                errorlist = require("program.run_program").get_opts(),
                filetypes = require("program.run_program").filetypes
            }
        )
    )
end

return M
