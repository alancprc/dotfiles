" Vimrc for both Linux and Windows

source $VIMRUNTIME/vimrc_example.vim
set nocompatible

" ========================================
" backspace, ambiwidth, history, diffopt
" ========================================
" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Chinese punctuation width
set ambiwidth=double

" keep command line history
set history=1000

" Diff option
set diffopt+=iwhite

" ========================================
" undo file, swap file, backup file
" ========================================
set nobackup

if has("unix") && v:version >= 703
    set undodir=~/.vim/undodir
    set undofile
elseif v:version >= 703
    set noundofile
endif

" make a backup before overwriting a file.
set writebackup
set noswapfile

" ========================================
" Tab, indent, ruler, number, wrap
" ========================================
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" auto indent
set autoindent

" smart indet
set smartindent

" show the cursor position all the time
set ruler

" display incomplete commands
set showcmd

" show line number
set number

" highlight the match brackets
set showmatch

" list char, apply for 'set list'
"set listchars=tab:\|\ ,eol:$,trail:-
set listchars=tab:\|\ ,trail:-,extends:>,precedes:<,eol:$

" wrap
set nowrap

" ========================================
" Color, search
" ========================================
syntax on

" do incremental searching
set incsearch

" highlight the search result
set hlsearch

" ========================================
" Encoding
" ========================================
" internal encoding, recommand utf-8, a Unicode encoding
" a non-Unicode encoding will cause info lost.
set encoding=utf-8

" file encoding for a new file
set fileencoding=utf-8

" terminal
set termencoding=utf-8

" file encoding sequence to detecte a existed file.
set fileencodings=ucs-bom,utf-8,euc-cn,cp936

if has("unix")
    set fileencoding=utf-8
    set termencoding=utf-8
elseif has("win32")
    set fileencoding=cp936
    set termencoding=cp936
endif

" ========================================
" Format
" ========================================
if has("unix")
    set fileformat=unix
elseif has("win32")
    set fileformat=dos
endif

set fileformats=unix,dos,mac

" ========================================
" GUI
" ========================================
"set go+=mbregLtT
set go=m

" ========================================
" Language
" ========================================
if has("unix")
    "set guifont=lucida\ console\ 10
    set guifont=Monospace\ 12
elseif has("win32")
    set guifont=lucida_console:h11

    " menu
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    " prompt
    language messages zh_CN.utf-8
endif

set helplang=cn

" ========================================
" Miscellaneous
" ========================================
" Auto read when a file is changed outside
set autoread

" file type detection
filetype on

" no error bell
set noerrorbells

" auto make
nmap <silent> <F5> :wa<CR>:make<CR>

" git commit message
autocmd FileType gitcommit setlocal tabstop=4

" ========================================
" leader key map
" ========================================
if v:version >= 801
    let mapleader = "\<Space>"
    nnoremap <Leader>w :w<CR>

    " shortcuts for yank/delete/past from/to system clipboard
    vmap <Leader>y "+y
    vmap <Leader>d "+d
    nmap <Leader>p "+p
    nmap <Leader>P "+P
    vmap <Leader>p "+p
    vmap <Leader>P "+P

    " close any 'Preview' window currently open.
    nmap <Leader>c :pc<CR>
endif

" ========================================
" clang format
" ========================================
function! FormatonSaveCpp()
  let l:formatdiff = 1
  pyf /usr/local/share/clang/clang-format.py
endfunction

autocmd FileType c,cpp map <C-K> :pyf /usr/local/share/clang/clang-format.py<cr>
autocmd FileType c,cpp imap <C-K> <c-o>:pyf /usr/local/share/clang/clang-format.py<cr>

"autocmd BufWritePre *.h,*.cc,*.cpp call FormatonSaveCpp()

" ========================================
" Perl tidy
" ========================================
" define :Tidy command to run perltidy on visual selection || entire buffer"
command -range=% -nargs=* Tidy <line1>,<line2>!perltidier

" run :Tidy on entire buffer
" and return cursor to (approximate) original position"
fun DoTidy()
    let Pos = line2byte( line( "." ) )
    :Tidy
    exe "goto " . Pos
endfun

autocmd FileType perl map <C-K> :Tidy<cr>
autocmd FileType perl imap <C-K> <c-o>:Tidy<cr>

"autocmd BufWritePre *.pm,*.pl call DoTidy()

" ========================================
" ctags
" ========================================
" set tags=tags;
" set autochdir
" 
" nmap <silent> <F9> :!ctags -R *<CR>

" ========================================
" taglist
" ========================================
let Tlist_Show_Menu = 0
let Tlist_Auto_Open=0

let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Close_On_Select = 0
nnoremap <silent> <F8> :TlistToggle<CR>

" ========================================
" gtags.vim
" ========================================
"let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = '/etc/gtags.conf'
let GtagsCscope_Auto_Load = 1
let CtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1

" ========================================
" YouCompleteMe
" ========================================
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0

let g:ycm_min_num_identifier_candidate_chars = 2
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1

let g:ycm_semantic_triggers = { 'c,cpp,python,perl': ['re!\w{2}'] }
" auto close preview windows, doesn't work however.
let g:ycm_autoclose_preview_windows_after_completion = 1
let g:ycm_autoclose_preview_windows_after_insertion = 1

" ========================================
" junegunn/vim-plug
" ========================================
" installation
if v:version >= 801
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin('~/.vim/plugged')

    Plug 'plasticboy/vim-markdown'
    Plug 'iamcco/markdown-preview.nvim', { 'do' : { -> mkdp#util#install() } }
    " Plug 'iamcco/markdown-preview.nvim', { 'do' : 'cd app & yarn install' }
    Plug 'junegunn/limelight.vim'
    Plug 'junegunn/goyo.vim', { 'for' : 'markdown' }
    Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clang-completer' }
    Plug 'jlanzarotta/colorSchemeExplorer'
    Plug 'yegappan/taglist'
    Plug 'brookhong/cscope.vim'
    Plug 'altercation/vim-colors-solarized'
    " Plug 'tpope/vim-fugitive'
    " Plug 'townk/vim-autoclose'
    call plug#end()
endif

" ========================================
" plasticboy/vim-markdown
" ========================================
autocmd FileType markdown let b:sleuth_automatic=0
autocmd FileType markdown set conceallevel=0
autocmd FileType markdown normal zR

let g:vim_markdown_frontmatter=1

" ========================================
" iamcco/markdown-preview.nvim
" ========================================
let g:mkdp_refresh_slow=1
let g:mkdp_markdown_css='/home/aliang/.github_markdown_css/github-markdown.css'

" ========================================
" color scheme
" ========================================
colorscheme solarized
set background=light

if has("unix") && has("gui_running")
    set background=dark
endif

if &diff
    set noreadonly
    colorscheme delek
    colorscheme default
endif
