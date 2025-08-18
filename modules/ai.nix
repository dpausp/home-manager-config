{
  config,
  pkgs,
  pkgs-stable,
  ...
}:

with builtins;

{
  home.packages = with pkgs; [
    python3Packages.huggingface-hub
    pkgs-stable.ollama
  ];

  programs.zsh.shellAliases = {
  };
}
