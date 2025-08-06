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

      # Neu: für Linting/Formatting mit externen Tools
      null-ls-nvim

      # Neu: automatisch Schemas laden (inkl. pyproject.toml)
      SchemaStore-nvim
      
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
    
    extraLuaConfig = builtins.readFile ./neovim_extra.lua;
  };
  
  # Minimal required packages
  home.packages = with pkgs; [
    nil                                    # Nix LSP
    python3Packages.python-lsp-server     # Python LSP
    ripgrep                               # For telescope search
    taplo
  ];
}
