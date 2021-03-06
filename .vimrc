" Vimrc for both Linux and Windows

source $VIMRUNTIME/vimrc_example.vim
set nocompatible

" ========================================
" junegunn/vim-plug
" ========================================
" installation
if v:version >= 801
    if has("unix") && empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

    call plug#begin('~/.vim/plugged')

    Plug 'plasticboy/vim-markdown'
    Plug 'iamcco/markdown-preview.nvim', { 'do' : { -> mkdp#util#install() } }
    " Plug 'iamcco/markdown-preview.nvim', { 'do' : 'cd app & yarn install' }
    Plug 'sindresorhus/github-markdown-css', { 'branch' : 'gh-pages' }
    Plug 'junegunn/limelight.vim'
    Plug 'junegunn/goyo.vim', { 'for' : 'markdown' }
    " for CentOS 6, only libclang is available
    " Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clang-completer' }
    " for CentOS 7/Arch, use clangd
    Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --clangd-completer', 'frozen' : 1 }
    Plug 'davidhalter/jedi-vim'
    Plug 'jlanzarotta/colorSchemeExplorer'
    Plug 'alancprc/vim-taglist'
    Plug 'brookhong/cscope.vim'
    Plug 'altercation/vim-colors-solarized'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'skywind3000/gutentags_plus'
    " Plug 'tpope/vim-fugitive'
    " Plug 'townk/vim-autoclose'
    Plug 'octol/vim-cpp-enhanced-highlight'

    Plug 'skywind3000/vim-auto-popmenu'
    Plug 'skywind3000/vim-dict'
    call plug#end()
endif

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

    " close any 'Preview'/'Quickfix' window currently open.
    nmap <Leader>c :pc <bar> cclose<CR>
endif
" close all
nnoremap <silent> <F4> :qa!<CR>

" ========================================
" color scheme
" ========================================
colorscheme solarized
set background=light
let g:solarized_diffmode="high"    "default value is normal

if &diff
    set noreadonly
    colorscheme solarized
endif

" ========================================
" Miscellaneous
" ========================================
" Auto read when a file is changed outside
set autoread
" auto change dir to current file
set autochdir

" file type detection
filetype on

" no error bell
set noerrorbells

" auto make
nmap <silent> <F5> :wa<CR>:make<CR>

" git commit message
autocmd FileType gitcommit setlocal tabstop=4

" ========================================
" clang format
" ========================================
function! FormatonSaveCpp()
  let l:formatdiff = 1
  py3f /usr/share/clang/clang-format.py
endfunction

autocmd FileType c,cpp map <C-K> :py3f /usr/share/clang/clang-format.py<cr>
autocmd FileType c,cpp imap <C-K> <c-o>:py3f /usr/share/clang/clang-format.py<cr>

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
" gtags
" ========================================
let $GTAGSLABEL = 'native' "'native-pygments'
let $GTAGSCONF = '/usr/share/gtags/gtags.conf'
let GtagsCscope_Auto_Load = 1
let CtagsCscope_Auto_Map = 1
let GtagsCscope_Quiet = 1
set cscopeprg=gtags-cscope

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
" prevent clangd add header files
let g:ycm_clangd_args = [ '--header-insertion=never' ]

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
let g:mkdp_markdown_css='/home/aliang/.vim/plugged/github-markdown-css/github-markdown.css'

" ========================================
" ludovicchabant/vim-gutentags
" ========================================
" gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 同时开启 ctags 和 gtags 支持：
let g:gutentags_modules = []
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
	let g:gutentags_modules += ['gtags_cscope']
endif

" 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let g:gutentags_cache_dir = expand('~/.cache/tags')

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 如果使用 universal ctags 需要增加下面一行
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

" 禁用 gutentags 自动加载 gtags 数据库的行为
let g:gutentags_auto_add_gtags_cscope = 0

" let g:gutentags_define_advanced_commands = 1

" ========================================
" skywind3000/gutentags_plus
" ========================================
" enable gtags module
let g:gutentags_modules = ['ctags', 'gtags_cscope']

" config project root markers.
let g:gutentags_project_root = ['.root', '.svn', '.git']

" generate datebases in my cache directory, prevent gtags files polluting my project
let g:gutentags_cache_dir = expand('~/.cache/tags')

" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1

" ========================================
" skywind3000/vim-auto-popmenu
" ========================================

" 设定需要生效的文件类型，如果是 "*" 的话，代表所有类型
let g:apc_enable_ft = {'text':1, 'markdown':1, 'php':1}

" 设定从字典文件以及当前打开的文件里收集补全单词，详情看 ':help cpt'
set cpt=.,k,w,b

" 不要自动选中第一个选项。
set completeopt=menu,menuone,noselect

" 禁止在下方显示一些啰嗦的提示
set shortmess+=c
