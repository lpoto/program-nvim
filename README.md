# program.nvim

## Requirements

- neovim v0.5+

## Features

- asynchronous program running
  - allows setting interpreters, compilers and executions for each filetype
  - formater option may be added to the filetype if [neoformat](https://github.com/sbdchd/neoformat) installed

- Project specific lua configs saved in neovim's config directory

See all the availible functions with `:lua require('program').functions()`.

Edit a project's config with `:lua require('program').local_config()`.

Additional config files will be stored in `nvim/.projects/`.

## Configuration

Install with your favourite package manager.

- Installation with [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

```
	use {'lpoto/program.nvim'}
```

- It can be lazy loaded

```
	use {
		'lpoto/program.nvim',
		opt = true,
		module = {'program'}
		}
```

**NOTE** when lazy loading, the local config will be sourced only when you
first require the module

- Add [neoformat](https://github.com/sbdchd/neoformat) as a dependency

```
	use {
		'lpoto/program.nvim',
		opt = true,
		module = {'program'},
		requires = {
				{
					'sbdchd/neoformat',
					opt = true
				}
			}
		}

```

## example init.vim config

```VIM

" run the program with :R
" adding additional arguments to R will add them to the command executed in terminal
command! -complete=file -nargs=* R lua require('program').run_program(<q-args>)

" edit project's local config with :Config
command! Config lua require('program').local_config()

command! ConfigSource lua require('program').source_local_config()

"togle terminal with "f4"
nnoremap <F4> <cmd>lua require('program').toggle_terminal()<CR>
tnoremap <F4> <C-\><C-n><cmd>lua require('program').toggle_terminal()<CR>

"togle errorlist with "<leader> + e""
nnoremap <leader>e <cmd>lua require('program').toggle_errorlist()<CR>

"neoformat with "<leader> + f"
nnoremap <leader>f <cmd>lua require('program').format()<CR>

```

```LUA
lua <<EOF

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

**NOTE** Same config can be added to a project's config file, local config has priority

**NOTE** paths in args can be given unexpanded (see `:h expand`),
unexpanded patterns are detected in strings separated with `.` or `/` aswell
(example: `"%:p:h/bin/%:p:t:r.class"` would expand into `path-to-file's-directory/bin/file-name-with-extension-replaced-with-.class`)

**NOTE** If there is `.git` folder in project's root, the root path will be detected
even if your curent working directory is in a subdirectory.
