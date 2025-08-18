{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs; [
    (pkgs.python310.overrideAttrs (_: {
      meta.priority = 6;
    }))
    (pkgs.python311.overrideAttrs (_: {
      meta.priority = 5;
    }))
    (pkgs.python312.overrideAttrs (_: {
      meta.priority = 4;
    }))
    (pkgs.python313.overrideAttrs (_: {
      meta.priority = 3;
    }))
    pkgs.mypy
    pkgs.pre-commit
    ruff
    uv
  ];

  programs.zsh.initContent = ''
    # Tool-specific completions
    eval "$(uv generate-shell-completion zsh)"
  '';

}
