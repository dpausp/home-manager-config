{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      # File navigation
      telescope-nvim
      nvim-tree-lua
      
      # LSP & Completion - das Wichtigste
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      
      # Syntax highlighting
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.python
        p.lua
        p.json
        p.bash
      ]))
      
      # Simple theme
      onedark-nvim
      
      # Basic utilities
      comment-nvim
      nvim-autopairs
    ];
    
    extraLuaConfig = ''
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
    '';
  };
  
  # Minimal required packages
  home.packages = with pkgs; [
    nil                                    # Nix LSP
    python3Packages.python-lsp-server     # Python LSP
    ripgrep                               # For telescope search
  ];
}
