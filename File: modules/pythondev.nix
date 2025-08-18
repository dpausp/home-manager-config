{ pkgs, pkgs-stable, lib, ... }:

with builtins;

{
  home.packages = with pkgs-stable; [
    (python312.overrideAttrs (_: { meta.priority = 4; }))
    (python313.overrideAttrs (_: { meta.priority = 3; }))
  ] ++ ([
    pkgs.mypy
    pkgs.pre-commit
    pkgs.ruff
    pkgs.uv
  ]);

  programs.zsh.initContent = ''
    # Tool-specific completions
    eval "$(uv generate-shell-completion zsh)"
  '';

}
