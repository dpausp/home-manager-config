# Platform-independent, graphical
{ pkgs, ... }:

with builtins;

{
  programs.vim = {
    packageConfigurable = pkgs.vim_configurable;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      statix
      syntastic
      unite
      vim-airline
      vim-dirdiff
      vim-endwise
      vim-fugitive
      vim-markdown
      vim-nix
      vim-pandoc
      vim-repeat
      vim-surround
    ];
  };
}
