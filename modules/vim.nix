{
  config,
  lib,
  pkgs,
  ...
}:

with builtins;

{
  programs.vim = {
    enable = true;
    packageConfigurable = lib.mkDefault (
      pkgs.vim_configurable.override {
        config = {
          vim = {
            gui = "none";
          };
        };
      }
    );

    extraConfig = readFile ./vimrc;
    plugins =
      with pkgs.vimPlugins;
      [
        ale
        nginx-vim
        unite
        vim-airline
        vim-dirdiff
        vim-indent-object
        vim-jinja
        vim-endwise
        vim-nix
        vim-repeat
        vim-sensible
        SyntaxRange
        vim-surround
      ]
      ++ (with pkgs; [
        vim-myplugin
      ]);
  };
}
