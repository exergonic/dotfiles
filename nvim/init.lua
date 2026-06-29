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

-- Setup lazy.nvim {{{
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-- Disable netrw (Must be before lazy.setup)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
		branch = "main", -- Explicitly use the new main branch
		build = ":TSUpdate",
		lazy = false, -- Ensure loaded at startup
		---@type TSConfig
		opts = {
			ensure_installed = { "python", "lua", "vim", "vimdoc", "query" },
			auto_install = true,
			-- Do NOT set highlight/indent here anymore in the new API
		},
		config = function(_, opts)
			local ts = require("nvim-treesitter")
			ts.setup(opts)

			-- Manually enable highlighting and indentation via autocmd (New API requirement)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					pcall(vim.treesitter.start)
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
    },
    install = { colorscheme = { "onehalfdark" } },
    checker = { enabled = true },
})
-- }}}

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
  ensure_installed = { "pyright", "ruff" },
  automatic_installation = true,
})

-- LSP
vim.lsp.config("*", {
  on_attach = function(client, bufnr)
    -- Set buffer-local keymaps
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "References" })
    vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code Action" })
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

-- 3. Configure Pyright (Extends the default config from nvim-lspconfig)
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true,
        autoSearchPaths = true,
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
vim.lsp.enable({ "pyright", "ruff" })

-- =============================================================================
-- 5. NVIM-CMP CONFIGURATION
-- =============================================================================
local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  auto_brackets = { "python" }, -- Critical for Python
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
-- Highlight to hide end-of-buffer tildes
-- vim.api.nvim_set_hl(0, 'EndOfBuffer', { ctermfg = 'black', ctermbg = 'black' })

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

-- Basic settings {{{
vim.opt.backspace = 'indent,eol,start'
vim.opt.ruler = true
vim.opt.showcmd = true
vim.opt.confirm = true
vim.opt.virtualedit = 'block'
vim.opt.history = 200
vim.opt.encoding = 'utf-8'
vim.opt.termguicolors = true  -- Enables 24-bit RGB colors (replaces t_Co=256)
vim.opt.list = true
vim.opt.listchars = { eol = '¬', tab = '»·', trail = '·' }
vim.opt.showmode = true
vim.opt.showmatch = true
vim.opt.cmdheight = 2
vim.opt.laststatus = 2
vim.opt.shortmess:append('I')
vim.opt.updatetime = 300
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescroll = 15
vim.opt.sidescrolloff = 15
vim.opt.numberwidth = 4
vim.opt.relativenumber = true
vim.opt.number = true
-- vim.opt.clipboard:append('unnamedplus')  -- Uncomment if needed
vim.opt.modeline = true
vim.opt.wildmenu = true
vim.opt.wildmode = { 'list:longest', 'full' }
vim.opt.autowrite = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.title = false
vim.opt.visualbell = true
vim.opt.smartindent = true
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

-- Backups and undo
vim.opt.backup = true
vim.opt.directory = vim.fn.expand('~/.local/state/nvim/swap//')
vim.opt.backupdir = vim.fn.expand('~/.local/state/nvim/backup//')
vim.opt.undodir = vim.fn.expand('~/.local/state/nvim/undo//')

-- Create directories if they don't exist
-- vim.fn.mkdir(vim.opt.directory:get(), 'p')
-- vim.fn.mkdir(vim.opt.backupdir:get(), 'p')
-- vim.fn.mkdir(vim.opt.undodir:get(), 'p')

vim.opt.undofile = true
vim.opt.undoreload = 10000
vim.opt.undolevels = 10000

-- Syntax and filetype
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on') -- }}}

-- Autocommands {{{
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

-- remove ending whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = '%s/\\s\\+$//e',
})

-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'WinEnter' }, {
--   pattern = 'term://*',
--   command = 'startinsert',
-- }) --


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

-- Code completion {{{
vim.opt.omnifunc = 'syntaxcomplete#Complete'
vim.opt.completeopt = { 'longest', 'menuone', 'preview' }
-- }}}

-- Mappings {{{
vim.keymap.set('i', ',,', '<Esc>')
vim.keymap.set('v', ',,', '<Esc>')
vim.keymap.set('t', ',,', '<C-\\><C-N>')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
-- }}}

-- Tabs {{{
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
--}}}

