
" VIMRC it's not a cake but not a lie

set nocompatible              " be iMproved, required
filetype off                  " required


"  Vundle Plugins

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" Navigation plugins
Plugin 'wincent/command-t'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'

" Development tools
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'

call vundle#end()
filetype plugin indent on


" General settings

syntax on
set number
set splitbelow	    " open files in splitscreen below
set splitright	    " open files in splitscreen on right
colorscheme sublimemonokai

set expandtab	    " use spaces instead of tabs
set tabstop=4	    " one tab equals four spacesset splitbelow

set mouse=a	        " enable full mouse support + wheel scrolling
set ttymouse=xterm2 " enable splits resizing by mouse
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

set wildmode=longest:list,full	" comandline autocompletion

let &colorcolumn=&textwidth	" highlight max line width
highlight ColorColumn ctermbg=darkgray


" Search settings

set hlsearch	" highlite search
set incsearch	" realtime search
set ic		" ignore character case while search
set hls		" highlight search results
set is		" ability to get next search result


" NERDtree settings

map <c-n> :NERDTreeToggle<cr>	

" run NERDtree if vim been runned without file specified
autocmd StdinReadPre * let s:std_in=1	
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif


" TagbarToggle (class tree) settings

nmap <F6> :TagbarToggle<CR>


" Open list of buffers by Ctrl + b

nnoremap <C-b> :Buffers<CR>


" Syntastic settings

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


" Powerline support for VIM

set rtp+=/usr/local/lib/python3.6/dist-packages/powerline/bindings/vim/
set laststatus=2	" Always show the statusline
set showtabline=2	" Disply more than one tabs
set t_Co=256		" 256 colors
