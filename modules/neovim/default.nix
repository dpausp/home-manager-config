{ pkgs, 
... 
}:

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

      # LSP & Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      null-ls-nvim
      nvim-surround
      SchemaStore-nvim
      vim-indent-object
      indent-blankline-nvim
      
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

    extraLuaConfig = builtins.readFile ./extra.lua;
  };

  # Minimal required packages
  home.packages = with pkgs; [
    nil # Nix LSP
    python3Packages.python-lsp-server # Python LSP
    ripgrep # For telescope search
    taplo
  ];
}
