# Platform-independent, graphical
{ pkgs, ... }:

with builtins;

{
  home.packages = with pkgs; [
    git-copy-commit-id
    git-copy-commit-msg
  ];

  nixpkgs.overlays = [
    (self: super: {

      git-copy-commit-id = pkgs.writeShellApplication {
        name = "git-copy-commit-id";
        text = ''
          commit=''${1:-HEAD}
          git rev-parse "$commit" | tr -d '\n' | "$CLIPBOARD_COPY_CMD"
        '';
      };

      git-copy-commit-msg = pkgs.writeShellApplication {
        name = "git-copy-commit-msg";
        text = ''
          commit=''${1:-HEAD}
          git log --format=%B -n1 "$commit" | "$CLIPBOARD_COPY_CMD"
        '';
      };

    })
  ];

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
