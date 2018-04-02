"YCM,function hints automatic imports, autocompletion, fuzzy completion
"make indentation levels visible
""artur-shail/vim-javacomplete2"
"golden ratio thing?
"github status display 'airblade/vim-gitgutter'
"vim-pencil, neocomplcache, vim-expand.
"make/find a macro that dives into a paragraph using the line width while soft wrapping
"it would be nice to be able to move both markers in visial mode. make a macro that changes which you are moveing
"back up on github
"'ctrlpvim/ctrlp.vim' and 
" 'nathanielkane/vim-indent-guides'
"create a macro to switch between settings for prose and code
"make a macro that will make it easier to change panes
"make the time for the jk==<esc> macro shorter
"possibly add a map to make it so <leader>w and <leader>b are on h and l for easymotion

"PLUGINS
call plug#begin('~/.vim/plugged')
Plug 'vim-syntastic/syntastic' "syntax checker
Plug 'easymotion/vim-easymotion' "makes moving about the screen faster
Plug 'tomtom/tcomment_vim' "comment things out with gcc(normal) and gc(visual)
Plug 'junegunn/goyo.vim' "removes distractions from screen when you type :Goyo
call plug#end()

"MISCELLANEOUS
let mapleader=" "
set nu "display line numbers
set so=5 "try to keep 5 lines between the cursor and the screen (vertically)
colorscheme desert
set spelllang=en_us "for use with ":set spell" and ":set spell!"
" syntax enable
" filetype plugin indent on

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
inoremap ll <esc>
inoremap hh <esc>

"MOTIONS
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

"syntastic settings
let g:syntastic_java_checkers = ['javac']
let g:syntastic_python_checkers = ['python' , 'pyflakes'] "pylint?
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=1
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

"EASYMOTION
"sets easymotion leader to be only one <leader>
map <leader> <plug>(easymotion-prefix)




