"==============================================================================
"------------------------------------------------------------------------------
"                                       READ FILETYPE SETTINGS FROM CONFIG FILE 
"==============================================================================
" This file will run last.
" On open look for an additional config file that allows project specific
" configurations.
"_____________________________________________________________________________

lua <<EOF
require('program.utils')
		.source_lua_file(
			require('program.utils')
			.config_file()
		)
EOF
