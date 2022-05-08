local M = {}

function M.setup(opts)
    if not opts then
        return
    end
    if type(opts) ~= "table" then
        print("WARNING program.nvim - setup.filetypes")
        print("Expected a table value for 'filetypes")
        return
    end
    local run = require("program.run_program")
    for filetype, v in pairs(opts) do
        if type(v) ~= "table" then
            print("WARNING program.nvim - setup.filetypes")
            print("Expected a table value for '" .. filetype .. "'")
            return
        end
        if not run.filetypes[filetype] then
            run.filetypes[filetype] = {}
        end
        if v.compiler and not v.execution then
            run.filetypes[filetype].execution = nil
        end
        for option, v2 in pairs(v) do
            if option == "compiler" or option == "interpreter" or option == "execution" then
                if type(v2) ~= "table" then
                    print("WARNING program.nvim - setup.filetypes")
                    print("Expected a table value for '" .. filetype .. "." .. option .. "'")
                    goto continue
                end
                if option ~= "execution" and v2.exe == nil then
                    print("WARNING program.nvim - setup.filetypes")
                    print("Missing 'exe' table key for '" .. filetype .. "." .. option .. "'")
                    goto continue
                end
                run.filetypes[filetype][option] = v2
            end
        end
        ::continue::
    end
end

return M
