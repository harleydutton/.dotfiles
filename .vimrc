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
"when i hit backspace in insert mode and there is nothing on the line but whitespace i want it to nuke the whole line and put me at the end of the previous line

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
" set so=5 "try to keep 5 lines between the cursor and the screen (vertically)
" while this was kinda neat it made the half-page-up/down motion inexact
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





"FUNCTIONS
function! GetLastVisualColumn()
    let originalPosition = getpos('.')
    let originalPosition = originalPosition+[originalPosition[2]]
    normal! g$
    let mycolumn = col('.')
    call setpos('.' , originalPosition)
    return mycolumn
endfunction

function CanDive()
    if col('$')-1 > GetLastVisualColumn()
        return 1
    else
        return 0
    endif
endfunction

function! GetFirstVisualColumn()
    let originalPosition = getpos('.')
    let originalPosition = originalPosition+[originalPosition[2]]
    normal! g0
    let mycolumn = col('.')
    call setpos('.' , originalPosition)
    return mycolumn
endfunction

function Dive()
    let myoffset = col('.')-GetFirstVisualColumn()
    let postdivecol = GetLastVisualColumn()+1
    call setpos('.',[0,line('.'),myoffset+postdivecol,0,myoffset+postdivecol])
endfunction

function! IfCanDiveDiveElseJ()
    if CanDive()
        call Dive()
    else
        normal! j
    endif
endfunction

function CanUnDive()
    if GetFirstVisualColumn() != 1
        return 1
    else
        return 0
    endif
endfunction

function UnDive()
    let myoffset = col('.')-GetFirstVisualColumn()
    let previousline = GetFirstVisualColumn()-1
    call setpos('.',[0,line('.'),previousline,0])
    call setpos('.',[0,line('.'),GetFirstVisualColumn()+myoffset,0])
endfunction

function! IfCanUnDiveUnDiveElseK()
    if CanUnDive()
        call UnDive()
    else
        normal! k
    endif
endfunction


nnoremap <f1> :echo CanDive()<cr>
nnoremap <f2> :call Dive()<cr>
nnoremap <silent> j :call IfCanDiveDiveElseJ()<cr>
nnoremap <f3> :echo CanUnDive()<cr>
nnoremap <f4> :call UnDive()<cr>
nnoremap <silent> k :call IfCanUnDiveUnDiveElseK()<cr>


" [bufnum, lnum, col, off, curswant]

" aaaaaaaaa aaaaaaaaaaa aaaaaaaaaaaaaa aaaaaaaaaaaaa aaaaaaaaaa aaaaaaaaa aaaaaaaaa aaaaXaaa aaaaaaaaaaa aaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaa aaaaaaaaaa aaaaaaaa a aaaaaaa aaaaYaaaaaa aaaaaaa a aaaaaaaa aa aaaaaaaa aa aaa aa a aaa aaa aaaaaaaaaaa aaaaaaa aa a aaaaaaaa aaaaa aa aa a a aaaa a
"okay so what do we want this to do? undive that is
"how to get from Y to X? y-first = offset
"okay so how do we get the first col of the line above?
"i guess we could set the cursor to first-1, then set it to first+offset

"okay so i havent even bothered keeping track of what the preferred column is or how it is changing and that is the main reason these arent perfect.
"THIS IS A BLOCK OF LONG TEXT FOR DEBUGGIN AND TESTING LINEDIVER. asdfasdf asd fasdf asdf asdfasdf asdf asd fasdfasdf asdfa sdfas df asdf asdfa sdf asdf   fasdf asd fasdf asd fa sdfasdfasd fasd fasdfasdfa sdfasdsfdaf afsdsafd fsad fsad fsad fsad sfadfsad fsdsafd asfdfsad fsadfds fdsa df asdf asfd fdsa sfda  fsdaafsdfsadfsda fsdsfad fsdasafd df fdsa afsd s adf asdf
" asdfasd f dfsasadf  afsdfsda  dfsafdsa  f  asdfasd asd f a sdfa df  sadfas d fa sdf asd fa sdf asd asd f asdf afs sad sadf f dasf dsa fd
"  asdf asf a
"  asd fa ds fa sf das df asdfas df a sd f asd f sda fas d fassda f sad fd sa
"  a sdf asd f asd fa sdf asd fa ds fa sd fas df as df sa fd as ds f asdf as df asd fas d fa sdf as df asd f asd as dfas df sadasfd s adf sdf fsad asdf fasdsdfas adf fsda afsd sdfa fsad afsd fsda fsda asfd fsda fsd fasd asfd fsad  fsda asfd asfd
"  a sfd asdf safd  asd fasd saf sfd fsd fsd fsda sdfa sfd fds



