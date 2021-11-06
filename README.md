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
* Project specific lua configs

See all the availible functions with `:lua require('program').functions()`
Edit a project's config with `:lua require('program').local_config()`
Additional config files will be stored in `nvim/.projects/`

## example init.vim config

**NOTE** Same config can be added to a project's config file

```LUA

lua <<EOF

-- run the program with :R
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
		size = 80,
		type = 0,
		save = true,
	},
	terminal = {
		size = 60,
		type = 0
	},

	keymaps = {
		toggle_terminal = {
			key = "<F4>",
			modes = {"n", "t"},
			args = {noremap = true}
		},
		toggle_errorlist = {
			key = "<leader>e",
			modes = {"n"}
		},
		format = {
			key = "<leader>f",
			modes = {"n"}
		}
	},

	format_unspecified = true

	filetypes = {
		java = {
			compiler = {
				exe = 'javac',
				args = {'%:p', '-d', '%:p:h/bin'},
			},
			execution = {
				exe = 'java',
				args = {'%:p'},
				end_args = {'-d', '%:p:h/bin'},
			},
			formater = {
				enabled = {'astyle'},
				astyle = {
					exe = 'astyle',
					args = {
						'--mode=java', '--indent=force-tab=4'
					},
					stdin = true
				},
				save = true
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

**NOTE** paths in args can be given unexpanded (see `:h expand`),
unexpanded patterns are detected in strings separated with `.` or `/` aswell (example: `"%:p:h/bin/%:p:t:r.class"`)
