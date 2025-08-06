-- Basic editor settings
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.termguicolors = true

-- Leader key
vim.g.mapleader = " "

-- Theme
require('onedark').setup({
  style = 'darker'
})
require('onedark').load()

-- File explorer
require("nvim-tree").setup()
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')

-- Telescope (file finder)
require('telescope').setup()
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>g', builtin.live_grep)

-- LSP setup
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Python LSP
lspconfig.pylsp.setup({
  capabilities = capabilities,
})

-- Nix LSP
lspconfig.nil_ls.setup({
  capabilities = capabilities,
})

-- Basic LSP keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
  end,
})

-- Simple completion
local cmp = require('cmp')
cmp.setup({
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
  }
})

-- Treesitter
require('nvim-treesitter.configs').setup({
  highlight = { enable = true },
})

-- Comments with gcc/gbc
require('Comment').setup()

-- Auto-close brackets
require('nvim-autopairs').setup()

-- Python: 4 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- Nix: 2 spaces
vim.api.nvim_create_autocmd("FileType", {
  pattern = "nix",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

-- === pyproject.toml: Schema + taplo Linting/Formatting ===

-- 1. Lade schemastore, um automatisch das pyproject.json Schema zu nutzen
local schemastore = require('schemastore')

-- 2. Konfiguriere yamlls (für TOML-Dateien mit JSON-Schema)
local lspconfig = require('lspconfig')
lspconfig.yamlls.setup({
  settings = {
    yaml = {
      -- Lade alle Schemas von schemastore.org
      schemas = schemastore.json.schemas(),
      -- Deaktiviere den eingebauten Schema-Store, weil wir unseren nutzen
      schemaStore = { enable = false },
    },
    -- Erlaube TOML-Dateien (obwohl es "yaml" heißt)
    filetypes = { "yaml", "yml", "json", "toml" },
  },
  -- Optional: nur wenn du Probleme hast
  init_options = {
    provideFormatter = false,  -- taplo macht das besser
  },
})

-- 3. null-ls: nutze taplo als Linter und Formatter
local null_ls = require('null_ls')
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.taplo,
    null_ls.builtins.formatting.taplo,
  },
  on_attach = function(client, bufnr)
    -- Formatierung beim Speichern
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end,
})
