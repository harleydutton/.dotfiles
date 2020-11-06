"MISCELLANEOUS
set nu "display line numbers
set spelllang=en_us "for use with ":set spell" and ":set spell!"

"BACKSPACE
set backspace=indent,eol,start
nnoremap <bs> X

"SEARCH OPTIONS
set ic "ignore case in searches
set hls "highlight searches
"this macro removes search highlighting when you press enter
nnoremap <cr> :noh<cr>:<bs><cr>

"WRAP
set colorcolumn=80 "this highlights the 80th column
set linebreak "this wraps on clean breaks rather than at the cutoff
autocmd FileType * set formatoptions-=c

"CONTROL
inoremap jk <esc>
inoremap kj <esc>
inoremap jj <esc>
inoremap kk <esc>

"MOTIONS
let mapleader=" "
nnoremap <leader>k <c-b>zz
nnoremap <leader>j <c-f>zz

"STATUS LINE
set laststatus=2 "status line always on
set statusline=
set statusline+=[col:%c]
set statusline+=[loc:%P]
set statusline+=%m
set statusline+=[%{getcwd()}/%t]

"INDENT
set tabstop=4 "this make a tab be 4 spaces
set expandtab "this akes tabs be as spaces
set shiftwidth=4 "chnges the shift width of the visual < and > commands


