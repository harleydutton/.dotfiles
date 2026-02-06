"MISCELLANEOUS
command! NU set number! "toggles line numbers
command! RLN set relativenumber! "toggles relative line numbers
set spelllang=en_us "for use with ":set spell" and ":set spell!"

"SEARCH OPTIONS
set ic "ignore case in searches
set hls "highlight searches
"enter: removes search highlighting
nnoremap <silent> <cr> :noh<Bar>:echo <CR>

"WRAP
set colorcolumn=120 "this highlights the 120th column
set linebreak "this wraps on clean breaks rather than at the cutoff
autocmd FileType * set formatoptions-=c

"CONTROL
inoremap jk <esc>
inoremap kj <esc>
inoremap jj <esc>
inoremap kk <esc>

"STATUS LINE
set laststatus=2 "status line always on
set statusline=
set statusline+=[col:%c]
set statusline+=[%{getcwd()}/%t]
set statusline+=%m

"INDENT
set tabstop=4 "this make a tab be 4 spaces
set expandtab "this akes tabs be as spaces
set shiftwidth=4 "chnges the shift width of the visual < and > commands
