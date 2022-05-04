# program-nvim

## Requirements

- neovim v0.5+

## Features

- asynchronous program running
  - allows setting interpreters, compilers and executions for each filetype

See all the available functions with `:lua require('program').functions()`.

## Configuration

Install with your favourite package manager.

- Installation with [wbthomason/packer.nvim](https://github.com/wbthomason/packer.nvim)

```LUA
use {'lpoto/program-nvim'}
```

- It can be lazy loaded

```LUA
use {
	'lpoto/program-nvim',
	opt = true,
	module = {'program'}
}
```

## example init.vim config

```VIM

" run the program with :R
" adding additional arguments to R will add them to the command executed in terminal
command! -complete=file -nargs=* R lua require('program').run_program(<q-args>)

"togle terminal with "f4"
nnoremap <F4> <cmd>lua require('program').toggle_terminal()<CR>
tnoremap <F4> <C-\><C-n><cmd>lua require('program').toggle_terminal()<CR>

"togle errorlist with "<leader> + e""
nnoremap <leader>e <cmd>lua require('program').toggle_errorlist()<CR>

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
		},

		python = {
			interpreter = {
				exe = "python3",
				args = {"%:p"}
			}
		}

        ['*'] = {
            interpreter = {
                exe = "echo"
                args = {"You can use star symbol to match all filetypes"}
            }
        }
	}
})
EOF

```

##

**NOTE** paths in args can be given unexpanded (see `:h expand`),
unexpanded patterns are detected in strings separated with `.` or `/` aswell
(example: `"%:p:h/bin/%:p:t:r.class"` would expand into `path-to-file's-directory/bin/file-name-with-extension-replaced-with-.class`)
