let mapleader = "\<Space>"

" Vim-Plug {{{1
call plug#begin(stdpath('config') . '/plugged')
function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

" Which key https://github.com/liuchengxu/vim-which-key
" Plug 'liuchengxu/vim-which-key'
"nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>

" Nice start page
Plug 'mhinz/vim-startify'

" Lots o' languages
Plug 'sheerun/vim-polyglot'

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

" Colorschemes {{{1
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
Plug 'kien/rainbow_parentheses.vim'
"{{{ RainbowParenthesis Options
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
""   let vim_markdown_preview_toggle=1
""   let vim_markdown_preview_hotkey='<C-m>'
""   let vim_markdown_preview_browser='Firefox'
""   let vim_markdown_preview_use_xdg_open=1

" Readline while in insert mode
Plug 'tpope/vim-rsi'

" Language Server
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"{{{
    if has('win32')
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

" Completion for python
Plug 'zchee/deoplete-jedi', {'for': 'python'}
    let g:deoplete#sources#jedi#show_docstring = 1

Plug 'jpalardy/vim-slime', {'for': ['python', 'scheme']}


call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" MISC {{{1
set nocompatible
filetype plugin on
filetype plugin indent on
syntax on
set ttyfast
set autochdir
" autocmd BufEnter * silent! lcd %:p:h
set backspace=indent,eol,start
set ruler
set showcmd
set confirm
set virtualedit=block
set history=200
set encoding=utf-8
set t_Co=256
set listchars=eol:¬,tab:»·,trail:·
set showmode
set showmatch
set cmdheight=2
set laststatus=2
set shortmess+=I
" }}}

" Folding {{{1
set foldcolumn=2
set foldmethod=marker
set foldnestmax=2
" }}}

" Backups and Undo {{{1
set backup
set directory=~/.temp
set backupdir=~/.temp
set undodir=~/.temp
set undolevels=10000
if has('persistent_undo')
    set undofile
    set undoreload=10000
endif
" }}}

set updatetime=300
set signcolumn=yes
set cursorline
set scrolloff=10
set sidescroll=15
set sidescrolloff=15
set numberwidth=4
set relativenumber
set number
set clipboard+=unnamedplus
set modeline
set wildmenu
set wildmode=list:longest,full
set autowrite
set autoread
set hidden
set notitle
set visualbell t_vb=
set novisualbell
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set autoindent
set splitbelow
set splitright
set pumheight=10
set helpheight=20





" Searching {{{1
set incsearch
set ignorecase
set smartcase
set nohlsearch

"GUI {{{1
set termguicolors
set bg=dark
colorscheme gruvbox
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_comments = '1'
set guifont=Source\ Code\ Pro
highlight Comment cterm=italic
" }}}


" SYNTAX {{{1
filetype plugin on
filetype plugin indent on
syntax on
" }}}

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

" }}}

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
    let g:python_host_prog = 'C:\Program Files\Python27\python.exe'
    let g:python3_host_prog = 'C:\Program Files\Python36\python.EXE'
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}

" Shell {{{1
let g:sh_indent_case_labels=1
" }}}

" KEY MAPPINGS {{{1

"let g:which_key_map = {}


set pastetoggle=<Leader>p

nnoremap Q <Nop>
nnoremap q <Nop>
nnoremap <Leader><Leader> :

"Avoid escape
inoremap ,, <Esc>
vnoremap ,, <Esc>
tnoremap ,, <C-\><C-N>

"Easy quit / save and quit etc
" nnoremap <silent><Leader>q :q<CR>
" nnoremap <silent><Leader>qa :qa<CR>
" nnoremap <silent><Leader>x :x<CR>
" nnoremap <silent><Leader>xa :xa<CR>


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
