-- Bootstrap lazy.nvim {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- }}}

-- Basic settings {{{
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.backspace = 'indent,eol,start'
vim.opt.showcmd = true
vim.opt.confirm = true
vim.opt.virtualedit = 'block'
vim.opt.history = 200
vim.opt.encoding = 'utf-8'
vim.opt.termguicolors = true
vim.opt.list = true
vim.opt.listchars = { tab = '»·', trail = '·' }
vim.opt.showmatch = true
vim.opt.laststatus = 2
-- vim.opt.shortmess:append('I')
vim.opt.updatetime = 300
vim.opt.timeoutlen = 500
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescroll = 15
vim.opt.sidescrolloff = 15
vim.opt.numberwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.clipboard:append('unnamedplus')
vim.opt.modeline = true
vim.opt.wildmode = { 'list:longest', 'full' }
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.title = false
vim.opt.visualbell = true
vim.opt.autoindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.pumheight = 10
vim.opt.helpheight = 20

-- Folding
vim.opt.foldcolumn = '2'
vim.opt.foldmethod = 'marker'
vim.opt.foldnestmax = 2

-- Searching
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Create directories if they don't exist
vim.fn.mkdir(vim.fn.expand('~/.local/state/nvim/swap//'), 'p')
vim.fn.mkdir(vim.fn.expand('~/.local/state/nvim/backup//'), 'p')
vim.fn.mkdir(vim.fn.expand('~/.local/state/nvim/undo//'), 'p')

-- Backups and undo
vim.opt.backup = true
vim.opt.directory = vim.fn.expand('~/.local/state/nvim/swap//')
vim.opt.backupdir = vim.fn.expand('~/.local/state/nvim/backup//')
vim.opt.undodir = vim.fn.expand('~/.local/state/nvim/undo//')
vim.opt.undofile = true
vim.opt.undoreload = 10000
vim.opt.undolevels = 10000

-- Code completion
vim.opt.omnifunc = 'syntaxcomplete#Complete'
vim.opt.completeopt = { 'longest', 'menuone' }

-- Tabs
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Syntax and filetype
vim.g.markdown_fenced_languages = { "vim", "help" }
vim.g.sh_indent_case_labels = 1
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Check if running on Windows and if bash is executable
if (vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1) and vim.fn.executable('bash') == 1 then
    vim.opt.shell = [["C:/Program Files/Git/usr/bin/bash.exe"]]
    vim.opt.shellcmdflag = '-c'
    vim.opt.shellxquote = ""
    vim.opt.shellslash = true
end

-- Disable netrw (Must be before lazy.setup)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- }}}

-- Setup Lazy {{{
require("lazy").setup({
    spec = {
        {
            "nvim-neo-tree/neo-tree.nvim",
            branch = "v3.x",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "MunifTanjim/nui.nvim",
                "nvim-tree/nvim-web-devicons", -- optional, but recommended
            },
            lazy = false, -- neo-tree will lazily load itself
            keys = {
                { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree"},
            },
        },
        {
            "MarcoKorinth/onehalf.nvim",
            lazy = false
        },
        {
            "folke/which-key.nvim",
            event = "VeryLazy",
            opts = {},
            config = function(_, opts)
                local wk = require("which-key")
                wk.setup(opts)
                wk.add({ --{{{
                    { "<leader><leader>", ":", desc = "Command mode", mode = "n" },
                    { "<leader>s", "<cmd>w<CR>", desc = "Write buffer", mode = "n" },
                    { "<leader>x", "<cmd>w<CR><cmd>!./%<CR>", desc = "Write and execute", mode = "n" },
                    { "<leader>y", '"+y', desc = "Yank to clipboard", mode = { "n", "v" } },
                    { "<leader>p", '"+p', desc = "Paste from clipboard", mode = "n" },
                    { "<leader>P", "<cmd>set invpaste<CR>", desc = "Toggle paste mode", mode = "n" },
                    { "<leader>o", "za", desc = "Toggle fold", mode = { "n", "v" } },
                    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "File explorer", mode = "n" },
                    { "<leader>b", group = "Buffer", mode = "n" },
                    { "<leader>bb", "<cmd>b #<CR>", desc = "Previous buffer" },
                    { "<leader>bl", "<cmd>ls<CR>", desc = "List buffers" },
                    { "<leader>bd", "<cmd>bd<CR>", desc = "Delete buffer" },
                    { "<leader>t", group = "Tab", mode = "n" },
                    { "<leader>tl", "<cmd>tabnext<CR>", desc = "Next tab" },
                    { "<leader>th", "<cmd>tabprev<CR>", desc = "Previous tab" },
                    { "<leader>tn", "<cmd>tabnew<CR>", desc = "New tab" },
                    { "<leader>w", group = "Window", mode = "n" },
                    { "<leader>wh", "<C-w>h", desc = "Window left" },
                    { "<leader>wj", "<C-w>j", desc = "Window down" },
                    { "<leader>wk", "<C-w>k", desc = "Window up" },
                    { "<leader>wl", "<C-w>l", desc = "Window right" },
                    { "<leader>wo", "<C-w>o", desc = "Only this window" },
                    { "<leader>wJ", "<C-w>J", desc = "Move window down" },
                    { "<leader>wK", "<C-w>K", desc = "Move window up" },
                    { "<leader>wH", "<C-w>H", desc = "Move window left" },
                    { "<leader>wL", "<C-w>L", desc = "Move window right" },
                    { "<leader>w=", "<C-w>=", desc = "Equalize windows" },
                    { "<leader>f", group = "File", mode = "n" },
                    { "<leader>fv", "<cmd>vertical wincmd f<CR>", desc = "Open in vsplit" },
                    { "<leader>fh", "<cmd>wincmd f<CR>", desc = "Open in split" },
                    { "<leader>ft", "<cmd>wincmd gf<CR>", desc = "Open in tab" },
                    { "<leader>v", group = "Vim", mode = "n" },
                    { "<leader>ve", "<cmd>tabnew $MYVIMRC<CR>", desc = "Edit config" },
                    { "<leader>vs", "<cmd>source $MYVIMRC<CR>", desc = "Source config" },
                    { "<leader>i", group = "Invert", mode = "n" },
                    { "<leader>il", "<cmd>set invlist<CR>", desc = "Toggle invisibles" }, --}}}
                })
            end,
        },
        {
            "alexghergh/nvim-tmux-navigation",
            config = function()
                require("nvim-tmux-navigation").setup({})
                vim.keymap.set("n", "<C-h>", require("nvim-tmux-navigation").NvimTmuxNavigateLeft)
                vim.keymap.set("n", "<C-j>", require("nvim-tmux-navigation").NvimTmuxNavigateDown)
                vim.keymap.set("n", "<C-k>", require("nvim-tmux-navigation").NvimTmuxNavigateUp)
                vim.keymap.set("n", "<C-l>", require("nvim-tmux-navigation").NvimTmuxNavigateRight)
                vim.keymap.set("n", "<C-\\>", require("nvim-tmux-navigation").NvimTmuxNavigateLastActive)
            end
        },
        {
            -- Mason for auto-installing LSP servers
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",

            -- LSP configuration
            "neovim/nvim-lspconfig",

            -- Autocompletion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",

            -- Snippets Engine (Required for Python parameter hints)
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "main",
            build = ":TSUpdate",
            lazy = false,
            opts = {
                ensure_installed = { "python", "lua", "vim", "vimdoc", "query" },
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            },
            config = function(_, opts)
                require("nvim-treesitter").setup(opts)
            end,
        },
        {
            'nvim-telescope/telescope.nvim', version = '*',
            dependencies = {
                'nvim-lua/plenary.nvim',
                -- optional but recommended
                { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            }
        },
    },
    install = { colorscheme = { "onehalfdark" } },
    checker = { enabled = true },
})
-- }}} End Setup Lazy

-- Mason, LSP, Autocompletion Setup {{{
-- LSP & Mason
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

-- Ensure servers are installed.
require("mason-lspconfig").setup({
  ensure_installed = { "ty", "ruff" },
  automatic_installation = true,
})

-- LSP
vim.lsp.config("*", {
  on_attach = function(client, bufnr)
    -- Set buffer-local keymaps
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename" })

    -- Enable completion capabilities if not already set by server
    if client.server_capabilities.completionProvider then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
  end,
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- 2. Extend Capabilities for nvim-cmp
-- We merge cmp capabilities into the global config so all servers get them.
local cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
  capabilities = vim.tbl_deep_extend("force", vim.lsp.config["*"].capabilities, cmp_capabilities),
})

-- 3. Configure ty (Extends the default config from nvim-lspconfig)
vim.lsp.config("ty", {
  settings = {
    ty = {
      inlayHints = {
        variableTypes = true,
        callArgumentNames = true,
      },
    },
  },
})

-- 4. Configure Ruff (Extends the default config)
vim.lsp.config("ruff", {
  init_options = {
    settings = {
      args = { "--fix" },
    },
  },
})

-- 5. Enable the servers
vim.lsp.enable({ "ty", "ruff" })

-- =============================================================================
-- 5. NVIM-CMP CONFIGURATION
-- =============================================================================
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  -- auto_brackets is handled by nvim-cmp-autopairs if installed
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "path" },
  }, {
    { name = "buffer" },
  }),
})
-- }}}

-- Gui {{{
vim.cmd("colorscheme onehalfdark")
vim.api.nvim_set_hl(0, 'EndOfBuffer', { ctermfg = 'black', ctermbg = 'black' })

-- Make transparent to match the terminal background
-- local function make_transparent()
--   local groups = {
--     'Normal',
--     'NormalNC',
--     'NormalFloat',
--     'SignColumn',
--     'LineNr',           -- Adds transparency to line numbers
--     'CursorLineNr',     -- Adds transparency to the current line number
--     'StatusLine',
--     'StatusLineNC',
--     'EndOfBuffer',
--     'FloatBorder'
--   }
--
--   for _, group in ipairs(groups) do
--     vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
--   end
-- end
--
-- make_transparent()
--
-- vim.api.nvim_create_autocmd('ColorScheme', {
--   callback = make_transparent,
-- })


-- }}}

-- Autocommands {{{

-- restore cursor to position in buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Don't prepend comments to lines on new line creation
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.opt.formatoptions:remove({ 'r', 'o' })
  end,
})

-- Make some files executable on write
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.zsh', '*.sh', '*.py', '*.csh', '*.scm' },
  callback = function()
    vim.fn.system('chmod +x ' .. vim.fn.expand('%'))
  end,
})

-- sh and zsh files have 2 spaces for shiftwidth and tab
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'zsh' },
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.expandtab = false
  end,
})

-- remove ending whitespace on save, while preserving cursor posotion
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[%s/\s\+$//e]])
    vim.api.nvim_win_set_cursor(0, pos)
  end
})

-- Auto-cd to current file's directory
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*',
  callback = function()
    vim.cmd('silent! lcd %:p:h')
  end,
})

-- Start insert mode in terminal buffers
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'WinEnter' }, {
  pattern = 'term://*',
  command = 'startinsert',
})

-- Python-specific overrides
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.bo.smartindent = false
  end,
})

-- Muttrc / email textwidth
vim.api.nvim_create_autocmd('BufRead', {
  pattern = '/tmp/mutt-*',
  callback = function()
    vim.opt.textwidth = 72
  end,
})

-- Close preview window if I move the cursor
vim.api.nvim_create_autocmd('CursorMovedI', {
  pattern = '*',
  callback = function()
    if vim.fn.pumvisible() == 0 then
      vim.cmd('pclose')
    end
  end,
})

-- Close preview window if I leave insert mode
vim.api.nvim_create_autocmd('InsertLeave', {
  pattern = '*',
  callback = function()
    if vim.fn.pumvisible() == 0 then
      vim.cmd('pclose')
    end
  end,
}) -- }}}

-- Mappings {{{

-- ",," is escape in all modes
vim.keymap.set('i', ',,', '<Esc>')
vim.keymap.set('v', ',,', '<Esc>')
vim.keymap.set('t', ',,', '<C-\\><C-N>')
vim.keymap.set('c', ',,', '<Esc>')

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', 'Q', '<Nop>')
vim.keymap.set('n', 'q', '<Nop>')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- }}}

