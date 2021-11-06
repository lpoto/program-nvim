# program.nvim

## Requirements
* neovim v0.5+

## Configuration

Install with your favourite package manager.

* Intallation with [vim-plug](https://github.com/junegunn/vim-plug):
```
	Plug 'lpoto/program.nvim'
```
## Features 

* asynchronous program running
	- allows setting interpreters, compilers and executions for each filetype
	- formater option may be added to the filetype if [neoformat](https://github.com/sbdchd/neoformat) is installed
* Project specific lua configs saved in neovim's config directory

See all the availible functions with `:lua require('program').functions()`.

Edit a project's config with `:lua require('program').local_config()`.

Additional config files will be stored in `nvim/.projects/`.

## example init.vim config


```LUA

lua <<EOF

-- run the program with :R
-- adding additional arguments to R will add them to the command executed in terminal
vim.api.nvim_command[[
	command! -complete=file -nargs=* R lua require('program').run_program(<q-args>)
]]

-- edit project's local config with :Config
vim.api.nvim_command[[
	command! Config lua require('program').local_config()
]]

-- source project's local config with :ConfigSource
vim.api.nvim_command[[
	command! ConfigSource lua require('program').source_local_config()
]]

require('program').setup({
	errorlist = {
		size = 80, --size of the errorlist window
		type = 0, -- 0 - vertical split, 1 - horizontal split
		save = true -- save when running the program
	},
	terminal = {
		size = 60, --size of terminal window
		type = 0 -- 0 - vertical, 1 - horizontal
	},

	-- remaps
	keymaps = {
		-- toggle terminal window with "f4"
		toggle_terminal = {
			key = "<F4>",
			modes = {"n", "t"},
			args = {noremap = true, silent = true}
		},
		-- toggle the program's errorlist with "leader + e"
		toggle_errorlist = {
			key = "<leader>e",
			modes = {"n"},
			args = {noremap = true}
		},
		-- format the file with "leader + f"
		format = {
			key = "<leader>f",
			modes = {"n"},
			args = {noremap = true}
		}
	},

	-- format even if no formater provided
	format_unspecified = true

	filetypes = {
		java = {
			compiler = {
				exe = 'javac',
				args = {'%:p', '-d', '%:p:h/bin'},
			},
			execution = {
				-- command called in terminal after compiling
				exe = 'java',
				args = {'%:p'},
				-- end args will be added to the command last,
				-- even after additional arguments added when calling the function
				end_args = {'-d', '%:p:h/bin'},
			},
			-- neoformat
			formater = {
				enabled = {'astyle'},
				astyle = {
					exe = 'astyle',
					args = {
						'--mode=java', '--indent=force-tab=4'
					},
					stdin = true
				},
				save = true -- save the file when formating
			}
		},

		python = {
			interpreter = {
				exe = "python3",
				args = {"%:p"}
			},
			formater = {
				enabled = {'autopep8'}
			}
		}
	}
})
EOF

```
**NOTE** Same config can be added to a project's config file


**NOTE** paths in args can be given unexpanded (see `:h expand`),
unexpanded patterns are detected in strings separated with `.` or `/` aswell
(example: `"%:p:h/bin/%:p:t:r.class"` would expand into `path-to-file's-directory/bin/file-name-with-extension-replaced-with-.class`)


**NOTE** If there is `.git` folder in project's root, the root path will be detected
even if your curent working directory is in a subdirectory.
