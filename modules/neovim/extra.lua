-- Basic editor settings
vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.switchbuf = "usetab,newtab"  -- Jump to existing tab or create new one

-- Leader key
vim.g.mapleader = " "

-- keybindings

vim.keymap.set("v", "<D-c>", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select pasted text' })

-- Smart paste with auto-indent
vim.keymap.set('n', 'p', 'p`[v`]=', { desc = 'Paste and auto-indent' })
vim.keymap.set('n', 'P', 'P`[v`]=', { desc = 'Paste before and auto-indent' })

-- Use tabs instead (gt/gT work by default)
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>to', ':tabonly<CR>', { desc = 'Close other tabs' })


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
 local capabilities = require('cmp_nvim_lsp').default_capabilities()
 
 -- Python LSP
 vim.lsp.config.pylsp = {
   capabilities = capabilities,
 }
 vim.lsp.enable('pylsp')
 
 -- Nix LSP
 vim.lsp.config.nil_ls = {
   capabilities = capabilities,
 }
 vim.lsp.enable('nil_ls')

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

require('ibl').setup()

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
vim.lsp.config.yamlls = {
  settings = {
    yaml = {
      schemas = vim.tbl_extend("force", schemastore.json.schemas(), {
        ["file:///Users/rovodev/git/hm-config/modules/neovim/opencode-schema.json"] = "*.json",  -- Lokales opencode-Schema
      }),
      schemaStore = { enable = false },
    },
    filetypes = { "yaml", "yml", "json", "toml" },
  },
  init_options = {
    provideFormatter = true,
  },
}
 vim.lsp.enable('yamlls')
