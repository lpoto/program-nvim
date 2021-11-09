"==============================================================================
"------------------------------------------------------------------------------
"                                       READ FILETYPE SETTINGS FROM CONFIG FILE
"==============================================================================
" This file will run last.
" On open look for an additional config file that allows project specific
" configurations.
"_____________________________________________________________________________

lua require('program').source_local_config()
