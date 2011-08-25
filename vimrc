" Vim configuration file
" author: Lei Xu <eddyxu@gmail.com>
set nocompatible
filetype on
filetype plugin on
set nobackup
set autowrite
set clipboard=unnamed
set background=dark
syntax on
colorscheme desert
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff},\ %{&fenc}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2
set visualbell
set nohlsearch
set wildmenu
set wildmode=longest:full
set mouse=a
set lazyredraw
set number
set foldenable
set foldmethod=indent
set foldlevel=100
set foldopen-=search
set foldopen-=undo
set formatoptions=ro
set guioptions-=T " remove toolbar
set cindent
set autoindent
set smartindent
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab
set smarttab

" general settings
au BufWritePre * :%s/\s\+$//e

" Taglist
let Tlist_Sort_Type = "name" " order by
let Tlist_Use_Right_Window = 1 " split to the right side of the screen
let Tlist_Show_Menu = 1
let Tlist_Display_Prototype = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Enable_Fold_Column = 0
map <C-C> <ESC>:Tlist<RETURN>
set tags=~/.vim/tags,~/tags,./tags,../tags,../../tags
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" for c/h switch
let g:alternateExtensions_h = "c,cpp,cc,m"
let g:alternateExtensions_cpp = "h"
let g:alternateExtensions_c = "h"
let g:alternateExtensions_m = "h"
let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc,reg:/include/src/g,reg:/src/include/g'
map <F3> <ESC>:A<CR>

" for NERDTree
map <C-X><C-C> <ESC>:NERDTree<RETURN>
let NERDTreeIgnore=['.*>o$', 'Makefile>in$', '.*>a$']

" autocomplet parenthess
:inoremap ( ()<ESC>i
		:inoremap ) <c-r>=ClosePair(')')<CR>
:inoremap { {}<ESC>i
:inoremap } <c-r>=ClosePair('}')<CR>
:inoremap [ []<ESC>i
:inoremap ] <c-r>=ClosePair(']')<CR>
":inoremap < <><ESC>i
":inoremap > <c-r>=ClosePair('>')<CR>

function ClosePair(char)
	if getline('.')[col('.') - 1] == a:char
		return "\<Right>"
	else
		return a:char
	endif
endfunction

autocmd BufEnter * :syntax sync fromstart

map <C-B> <ESC>:e %:p:h<RETURN>
map <C-F4> <ESC>:bd<RETURN>
map <C-Left> <ESC>:bp!<RETURN>
map <C-Right> <ESC>:bn!<RETURN>

nmap <C-Down> :<C-u>move .+1<CR>
nmap <C-Up> :<C-u>move .-2<CR>

imap <C-Down> <C-o>:<C-u>move .+1<CR>
imap <C-Up> <C-o>:<C-u>move .-2<CR>

vmap <C-Down> :move '>+1<CR>gv
vmap <C-Up> :move '<-2<CR>gv

au FileType python set et tw=79 ts=4 sts=4 sw=4 autoindent sta
au FileType python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
let g:pydiction_location='~/.vim/ftplugin/complete-dict'

au FileType cpp set et sw=2 sts=2 cinoptions=l1,g0.5s,h0.5s,i2s,+2s,(0,W2s
au FileType c set et sw=2 sts=2 cinoptions=l1,g0.5s,h0.5s,i2s,+2s,(0,W2s

" set for make
map <C-b> :make<RETURN>
au BufEnter *_test.cpp set makeprg=make\ check\ %:r

