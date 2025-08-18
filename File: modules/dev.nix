{
  pkgs,
  ...
}:

with builtins;

{
  home.packages = with pkgs; [
    cloc
    diagnostic-languageserver
    gh
    gita
    pre-commit
  ];

}
