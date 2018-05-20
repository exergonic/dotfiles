" MISC {{{1

" Vim = Vi iMproved
set nocompatible

" Fast terminal connection
set ttyfast

" Set what backspace can move over in insert mode
set backspace=indent,eol,start

" Show line and column number of cursor position
set ruler

" Show command in last line of screen
set showcmd

" Confirm certain actions, such as quit
set confirm

" Allow virtual editing in Visual block mode.
" Virtual editing means that the cursor can be positioned
" where there is no actual character.
set virtualedit=block

" Keep this many command-lines in history table.
set history=200

" Set character encoding in buffers, registers, etc.
set encoding=utf-8

" Maximum amount of text that can be inserted
" set textwidth=100

" Number of colors
set t_Co=256

" Strings to use in `list` mode and :list command
set listchars=eol:¬,tab:»·,trail:·

" If in Insert, Replace or Visual mode put a message on the last line.
set showmode

" When a backet is inserted, briefly jump to the matching one
set showmatch

" Number of lines to use for the command-line
set cmdheight=2

" When will the last window have a status line: 2 = always
set laststatus=2

" Don't give intro message
set shortmess+=I

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" }}}

" Folding {{{1
" the fold column is `n` columns wide
set foldcolumn=2

" Fold points by using the marker method, as in this file
set foldmethod=marker

" Folds can be nested twice
set foldnestmax=2
" }}}

" Backups and Undo {{{1
" keep backups
set backup

" Because I don't usually keep backups for long, set them in the Trash
set backupdir=~/.Trash

" I don't normally keep undo's either
set undodir=~/.Trash

" Maximum number of changes that can be undone
set undolevels=10000

" Directory for swap file
set directory=~/.Trash

" Persistent undo's keep the tree of undo's created for a buffer in an undo file
if has('persistent_undo')
    set undofile
    set undoreload=10000
endif
" }}}

" Searching {{{1
" incremental searching
set incsearch

" ignore letter case
set ignorecase

" ignore case unless I include a capital letter by default
set smartcase

" don't highlight the search term
set nohlsearch

" }}}

" Misc settings {{{1
" Highlight the line where the cursor is.
set cursorline

" Scroll when I get to within `n` lines of buffer
set scrolloff=10

" Horizontally, as well
set sidescroll=15
set sidescrolloff=15

" Line numbers
" give the numberline 4 spaces wide
set numberwidth=4

" show numbers relative to the current line
set relativenumber

" but still show the absolute number of the current line
set number

" Use the clipboard for yank and delete
set clipboard+=unnamedplus

" A vim specific code may appear within a file
set modeline

" Enhanced ex command-line completion
set wildmenu
set wildmode=list:longest,full

" Save buffer when moving away from it
set autowrite

" Automatically read buffer when it's been changed from outside
set autoread

" Unload a buffer when it's hidden
set hidden

" No title at the top of window
set notitle

" Use visual bell instead of beeping. No terminal code disables visual bell
set visualbell t_vb=
set novisualbell

" In insert mode, TAB inserts appropriate number of spaces.
" stop a tab at `n` characters
set tabstop=4
set shiftwidth=4

" tabs are expanded to spaces
set expandtab

" Better indent
set smartindent
set autoindent

" When splitting the window, the buffer splits to right or below
set splitbelow
set splitright

" Set max number of items in pop-up for autocompletion
set pumheight=10

" Help window hight max
set helpheight=20

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" Vim-Plug {{{1
call plug#begin('~/.config/nvim/plugged')
function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

" Access to UNIX shell commands
Plug 'tpope/vim-eunuch'

" Fuzzy finder
Plug 'kien/ctrlp.vim'

" List of buffers
Plug 'bling/vim-bufferline'
let g:bufferline_echo = 0

" Display indentation with thin, vertical line
" Plug 'Yggdroot/indentLine'

" Status line
Plug 'bling/vim-airline'
  let g:airline#extensions#wordcount#enabled = 1
  let g:airline#extensions#bufferline#enabled = 1

" Colorschemes {{{2
Plug 'plan9-for-vimspace/acme-colors'
Plug 'altercation/vim-colors-solarized'
Plug 'liuchengxu/space-vim-dark'
Plug 'morhetz/gruvbox'
Plug 'stephenmckinney/vim-solarized-powerline'
" }}}

" Seemless movement between vim and tmux (cntrl+h|j|k|l movemnt)
Plug 'christoomey/vim-tmux-navigator'

" Filesystem explorer
Plug 'scrooloose/nerdtree' ", {'on': 'NERDTreeTabsToggle'}

" Visualize undo levels
Plug 'sjl/gundo.vim', {'on': 'GundoToggle'}

" Pretty parentheses to highlight matching pair
Plug 'kien/rainbow_parentheses.vim'

" Filesystem explorer
Plug 'vim-scripts/Ranger.vim'

" Manipulate columns of ordered data
Plug 'vim-scripts/VisIncr'

" Efficient toggling of commented code
Plug 'tpope/vim-commentary'

" Calculate mathematical visual selections
Plug 'vim-scripts/HowMuch'

" Launches a calculator in a buffer
Plug 'gregsexton/VimCalc'

" Distraction free writing
Plug 'junegunn/goyo.vim'

" Align columns to tokens
Plug 'godlygeek/tabular'

" Insert pairs of certain characters, e.g. parens.
Plug 'Raimondi/delimitMate'

" Syntax highlighting for i3 config file
Plug 'PotatoesMaster/i3-vim-syntax'

" Markdown
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'JamshedVesuna/vim-markdown-preview', {'for': 'markdown'}
    let vim_markdown_preview_toggle=1
    let vim_markdown_preview_hotkey='<C-m>'
    let vim_markdown_preview_browser='Firefox'
    let vim_markdown_preview_use_xdg_open=1

" Readline while in insert mode
Plug 'tpope/vim-rsi'

" Programming {{{2

" Code linting
Plug 'scrooloose/syntastic'

" Code completion
Plug 'Shougo/deoplete.nvim', {'do': function('DoRemote')}
let g:deoplete#enable_at_startup = 1

" Completion for python
Plug 'zchee/deoplete-jedi', {'for': 'python'}
let g:deoplete#sources#jedi#show_docstring = 1

Plug 'fs111/pydoc.vim', {'for': 'python'}
Plug 'jpalardy/vim-slime', {'for': ['python', 'scheme']}

Plug 'wlangstroth/vim-racket' , {'for': 'racket'}
Plug 'MicahElliott/vrod', {'for': 'racket'}

Plug 'bhurlow/vim-parinfer', {'for': ['scheme', 'racket', 'clojure', 'lisp']}

Plug 'guns/vim-clojure-static', {'for': 'clojure'}
Plug 'clojure-emacs/cider', {'for': 'clojure'}
Plug 'tpope/vim-fireplace', {'for': 'clojure'}

Plug 'eagletmt/neco-ghc', {'for': 'haskell'}
Plug 'eagletmt/ghcmod-vim', {'for': 'haskell'}
Plug 'Shougo/vimproc', {'for': 'haskell','do' : 'make'}
Plug 'Twinside/vim-hoogle', {'for': 'haskell'}

Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}
" }}}

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

"GUI {{{1

set bg=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_comments = '1'

highlight Comment cterm=italic

if has("gui_running")
    " When in gui, remove menubar (m), toolbar (T), right scroll-bar (r)
    set guioptions=-m
    " set guioptions=-T   KEEP TOOLBAR FOR NOW
    set guioptions=-r
    set guifont=Inconsolata\ for\ Powerline\ Medium
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" SYNTAX {{{1

" Enable file type detection
filetype plugin on

" Load file type specific indentation file
filetype plugin indent on

" Use global sytax highlighting color settings
syntax on


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" AUTOCOMMANDS {{{1

" Restore cursor to position it was when last in particular file
autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Don't prepend a comment if Enter or (O|o) is pressed on a commented line
" fo == formatoptions
autocmd FileType * set fo-=r fo-=o

" mutt (email) files have a textwidth of `n`
autocmd BufRead /tmp/mutt-* set tw=72

" For shell files, indents are 2 and they are hard tabs
autocmd FileType sh set shiftwidth=2 tabstop=2 noexpandtab

" Mark scripts executable upon write
autocmd BufWritePost *.sh,*py,*.csh,*.scm silent !chmod +x %

" Ensure that markdown files are correctly recognized
autocmd BufNewFile,BufReadPost *.md,*.markd,*.markdown set filetype=markdown

" Auto remove all trailing whitespace on :w
autocmd BufWritePre * :%s/\s\+$//e

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

"CODE COMPLETION {{{1

" Use Vim builtin syntax knowledge for (minimal) completions
set omnifunc=syntaxcomplete#Complete

" Insert mode completion options:
"   longest: only insert the longest common text of the matches
"   menuone: Use the popup menu even if there's only one match
"   preview: show extra info about the currently selected completion
set completeopt=longest,menuone,preview

" Close preview window if I move the cursor
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif

" Close preview window if I leave insert mode
autocmd InsertLeave * if pumvisible() == 0|pclose|endif "close preview window

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" Python {{{1

" Ditto above, but for Python
autocmd FileType python set omnifunc=pythoncomplete#Complete

" Turn off smartindent for Python
autocmd FileType python setlocal nosmartindent

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" HASKELL {{{1

let g:haskellmode_completion_ghc = 1
autocmd Filetype haskell setlocal omnifunc=necoghc#omnifunc

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" FORTRAN {{{1

" Fortran77 has strict column rules for some compilers
" Distinguish between the two based upon file extension
if (&ft=='fortran')
    let s:extfname = expand("%:e")
    let fortran_do_enddo=1
    let fortran_more_precise=1
    let fortran_have_tabs=1
    if s:extfname ==? "f90"
        let fortran_free_source=1
        unlet! fortran_fixed_source
    else
        let fortran_fixed_source=1
        unlet! fortran_free_source
        autocmd FileType fortran set colorcolumn=6,73
    endif
endif " }}}

" SHELL {{{1

" indent CASE statement appropriately
let g:sh_indent_case_labels=1

" }}}

" EXTERNAL CONFIGS {{{1

" Key Mappings
source ~/.config/nvim/keymaprc

" Configs for plugins
source ~/.config/nvim/pluginrc

" For functions
source ~/.config/nvim/functions

" }}}
