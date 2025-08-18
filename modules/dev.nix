{
  pkgs,
  ...
}:

with builtins;

{
  home.packages = with pkgs; [
    cloc
    gh
    gita
    pre-commit
  ];

}
