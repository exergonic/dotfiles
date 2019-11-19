" Vim-Plug {{{1
call plug#begin(stdpath('config') . '/plugged')
function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

" Access to UNIX shell commands
Plug 'tpope/vim-eunuch'

" Fuzzy finder
Plug 'kien/ctrlp.vim'
    let g:ctrlp_cmd = 'CtrlPMixed'

" List of buffers
Plug 'bling/vim-bufferline'
    let g:bufferline_echo = 0

" Display indentation with thin, vertical line
Plug 'Yggdroot/indentLine'

" Status line
Plug 'bling/vim-airline'
    let g:airline#extensions#wordcount#enabled = 1
    let g:airline#extensions#bufferline#enabled = 1

Plug 'vim-airline/vim-airline-themes'
    let g:airline_theme = 'minimalist'

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
Plug 'scrooloose/nerdtree'
    let NERDTreeShowLineNumbers = 1
    let NERDChristmasTree = 1
    nnoremap <silent><Leader>n :NERDTreeToggle<CR>

" Visualize undo levels
Plug 'sjl/gundo.vim', {'on': 'GundoToggle'}

" Pretty parentheses to highlight matching pair
Plug 'kien/rainbow_parentheses.vim' "{{{
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
    let g:rbpt_colorpairs = [
        \ ['brown',       'RoyalBlue3'],
        \ ['Darkblue',    'SeaGreen3'],
        \ ['darkgray',    'DarkOrchid3'],
        \ ['darkgreen',   'firebrick3'],
        \ ['darkcyan',    'RoyalBlue3'],
        \ ['darkred',     'SeaGreen3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['brown',       'firebrick3'],
        \ ['gray',        'RoyalBlue3'],
        \ ['black',       'SeaGreen3'],
        \ ['darkmagenta', 'DarkOrchid3'],
        \ ['Darkblue',    'firebrick3'],
        \ ['darkgreen',   'RoyalBlue3'],
        \ ['darkcyan',    'SeaGreen3'],
        \ ['darkred',     'DarkOrchid3'],
        \ ['red',         'firebrick3'],
        \ ]
" }}}

" Efficient toggling of commented code
Plug 'tpope/vim-commentary'

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
Plug 'scrooloose/syntastic' "{{{
    "stick any detected errors into loc_list
    let g:syntastic_always_populate_loc_list = 1
    "error window will be automatically opened when errors are detected,
    "and closed when none are detected.
    let g:syntastic_auto_loc_list = 1
    " the err list is too damn high
    let g:syntastic_loc_list_height = 3
    " check on open
    let g:syntastic_check_on_open = 1
    " don't check on wq
    let g:syntastic_check_on_wq = 0
    " which checker's yelling at me?
    let g:syntastic_id_checkers = 1
    let g:syntastic_enable_racket_racket_checker = 1
    " show errors from all checkers
    " let g:syntastic_aggregate_errors = 1
    " enable balloons?
    let g:syntax_enable_baloons = 1
    " fancy color?
    highlight SyntasticError guibg=#2f0000
    " work around false flagging legit python3 constructs
    if has('win32')
        let g:syntastic_python_python_exec = 'C:\Program Files\Python36\python.EXE'
    else
        let g:syntastic_python_python_exec = '/usr/bin/python3'
    endif
    " if has("mac")
    "     let g:syntastic_python_python_exec = '/usr/local/bin/python3'
    " endif
    let g:syntastic_python_checkers = ['flake8', 'python', 'pep8']
    let g:syntastic_haskell_checkers = ['hlint', 'ghc_mod']
    let g:syntastic_error_symbol='✗'
    let g:syntastic_style_warning_symbol='†'
    let g:syntastic_warning_symbol='⚠' "}}}

" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
    if has('win32') "{{{
        let g:coc_node_path = 'C:/Users/arach/scoop/apps/nodejs/current/node.exe'
    endif

    " You will have bad experience for diagnostic messages when it's default 4000.
    set updatetime=300

    " don't give |ins-completion-menu| messages.
    set shortmess+=c

    " always show signcolumns
    set signcolumn=yes

    " Use tab for trigger completion with characters ahead and navigate.
    " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <c-space> to trigger completion.
    inoremap <silent><expr> <c-space> coc#refresh()

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
    " Coc only does snippet and additional edit on confirm.
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    " Or use `complete_info` if your vim support it, like:
    " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight symbol under cursor on CursorHold
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Remap for format selected region
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end

    " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap for do codeAction of current line
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Fix autofix problem of current line
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Create mappings for function text object, requires document symbols feature of languageserver.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
    nmap <silent> <C-d> <Plug>(coc-range-select)
    xmap <silent> <C-d> <Plug>(coc-range-select)

    " Use `:Format` to format current buffer
    command! -nargs=0 Format :call CocAction('format')

    " Use `:Fold` to fold current buffer
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " use `:OR` for organize import of current buffer
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add status line support, for integration with other plugin, checkout `:h coc-status`
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    " Using CocList
    " Show all diagnostics
    nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions
    nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
    " Show commands
    nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document
    nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols
    nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list
    nnoremap <silent> <space>r  :<C-u>CocListResume<CR>
"}}}

"Plug 'Shougo/deoplete.nvim', {'do': function('DoRemote')} "{{{
"    let g:deoplete#enable_at_startup = 1
"    let g:deoplete#num_processes = 1
"    let g:deoplete#complete_method = 'complete'
"    " Use smartcase.
"    let g:deoplete#enable_smart_case = 1
"    " Control the nubmer of the input completion at the time
"    " of the key input automatically
"    let g:deoplete#autocomplete_start_length = 0
"
"      "" Set minimum syntax keyword length.
"    let g:deoplete#sources#syntax#min_keyword_length = 1
"    let g:deoplete#lock_buffer_name_pattern = '\*ku\*'
"
"     " Define dictionary.
"    let g:deoplete#sources#dictionary#dictionaries = {
"         \ 'default' : '',
"         \ 'vimshell' : $HOME.'/.vimshell_hist',
"         \ 'scheme' : $HOME.'/.gosh_completions'
"         \ }
"    " Define keyword.
"    if !exists('g:deoplete#keyword_patterns')
"        let g:deoplete#keyword_patterns = {}
"    endif
"
"    let g:deoplete#keyword_patterns.tex = '\\?[a-zA-Z_]\w*'
"    let g:deoplete#keyword_patterns['default'] = '\h\w*'
"
"    " <C-h>, <BS>: close popup and delete backword char.
"    inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
"    inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
"
"    " <CR>: close popup and save indent.
"    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"    function! s:my_cr_function() abort
"      return deoplete#mappings#close_popup() . "\<CR>"
"    endfunction
"
"     inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"     function! s:my_cr_function()
"         return deoplete#close_popup() . "\<CR>"
"         "For no inserting <CR> key.
"         return pumvisible() ? deoplete#close_popup() : "\<CR>"
"     endfunction
"
"    " <TAB>: completion.
"    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"
"    " Enable heavy omni completion.
"    if !exists('g:deoplete#sources#omni#input_patterns')
"      let g:deoplete#sources#omni#input_patterns = {}
"    endif
" }}}


" Completion for python
Plug 'zchee/deoplete-jedi', {'for': 'python'}
    let g:deoplete#sources#jedi#show_docstring = 1

Plug 'jpalardy/vim-slime', {'for': ['python', 'scheme']}

" Plug 'fs111/pydoc.vim', {'for': 'python'}
" Plug 'wlangstroth/vim-racket' , {'for': 'racket'}
" Plug 'MicahElliott/vrod', {'for': 'racket'}
" Plug 'bhurlow/vim-parinfer', {'for': ['scheme', 'racket', 'clojure', 'lisp']}
" Plug 'guns/vim-clojure-static', {'for': 'clojure'}
" Plug 'clojure-emacs/cider', {'for': 'clojure'}
" Plug 'tpope/vim-fireplace', {'for': 'clojure'}

" }}}

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}


" MISC {{{1

" Vim = Vi iMproved
set nocompatible

filetype plugin on
filetype plugin indent on
syntax on

" Fast terminal connection
set ttyfast

" Move vim to dir of current buffer
set autochdir
" autocmd BufEnter * silent! lcd %:p:h

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

" How long before swap file is written to disk (ms)
set updatetime=300

" Always draw signcolumn
set signcolumn=yes

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
set backupdir=~/.temp

" I don't normally keep undo's either
set undodir=~/.temp

" Maximum number of changes that can be undone
set undolevels=10000

" Directory for swap file
set directory=~/.temp

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

"GUI {{{1
set termguicolors
set bg=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_comments = '1'
set guifont=Source\ Code\ Pro

highlight Comment cterm=italic

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

if has('win32')
    let g:python_host_prog = 'C:\Python27\python.exe'
    let g:python3_host_prog = 'C:\Program Files\Python36\python.EXE'
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" Shell {{{1
let g:sh_indent_case_labels=1
" }}}

" KEY MAPPINGS {{{1

"let g:which_key_map = {}

let mapleader = "\<Space>"

set pastetoggle=<Leader>p

nnoremap Q <Nop>
nnoremap q <Nop>
nnoremap <Leader><Leader> :

"Avoid escape
inoremap ,, <Esc>
vnoremap ,, <Esc>
tnoremap ,, <C-\><C-N>

"Easy quit / save and quit etc
nnoremap <silent><Leader>q :q<CR>
nnoremap <silent><Leader>qa :qa<CR>
nnoremap <silent><Leader>x :x<CR>
nnoremap <silent><Leader>xa :xa<CR>


""Buffers
nnoremap <silent><Leader>bb :b #<CR>
nnoremap <silent><Leader>bl :ls<CR>

""Tab movement
nnoremap <silent><Leader>tl :tabnext<CR>
nnoremap <silent><Leader>th :tabprev<CR>
nnoremap <silent><Leader>tn :tabnew<CR>

" Viewport Controls, ie moving between split panes
nnoremap <Leader>wj <C-w>j
nnoremap <Leader>wk <C-w>k
nnoremap <Leader>wh <C-w>h
nnoremap <Leader>wl <C-w>l
nnoremap <Leader>wo <C-w>o

" Move windows
nnoremap <Leader>wJ <C-w>J
nnoremap <Leader>wK <C-w>K
nnoremap <Leader>wH <C-w>H
nnoremap <Leader>wL <C-w>L

"let g:which_key_map['w'] = {
"            \ 'name' : '+windows' ,
"            \ 'j' : ['<C-w>j' , 'pane-down'] ,
"            \ 'k' : ['<C-w>k', 'pane-up'] ,
"            \ 'h' : ['<C-w>h' , 'pane-left'] ,
"            \ 'l' : ['<C-w>l' , 'pane-right'] ,
"            \ 'J' : ['<C-w>J' , 'move-pane-down'] ,
"            \ 'K' : ['<C-w>K' , 'move-pane-up'] ,
"            \ 'H' : ['<C-w>H' , 'move-pane-left'] ,
"            \ 'L' : ['<C-w>L' , 'move-pane-right'] ,
"            \ '<' : ['<C-w>5<' , 'decrease-panel-width'] ,
"            \ '>' : ['<C-w>5>' , 'increase-panel-width'] ,
"            \}

nnoremap <Leader>w<Left> 5<C-w><
nnoremap <Leader>w<Right> 5<C-w>>

" Editing files

"open file under cursor in vertical split
nnoremap <silent><Leader>fv :vertical wincmd f<CR>

"open file under cursor in horizotal split
nnoremap <silent><Leader>fh :wincmd f<CR>

"open file under cursor in new tab
nnoremap <silent><Leader>ft :wincmd gf<CR>

"Edit vimrc
nnoremap <silent><Leader>ve :tabnew $MYVIMRC<cr>

"Source vimrc
nnoremap <Leader>vs :source $MYVIMRC<cr>

"invert listing lisptchars
nnoremap <silent><Leader>il :set invlist<CR>

"Space-o toggles folds
nnoremap <Leader>o za
vnoremap <Leader>o za

nmap <C-j> 3j3<C-e>
nmap <C-k> 3k3<C-y>

" }}}

" vim: ft=vim
