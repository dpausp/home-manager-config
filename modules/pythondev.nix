{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs.python310Packages; [
    pkgs.python39
    (pkgs.python310.overrideAttrs (_: { meta.priority = 3; }) )
    (black.overridePythonAttrs (_: {
      propagatedBuildInputs = black.propagatedBuildInputs ++ black.optional-dependencies.d;
    }))
    isort
    pkgs.pre-commit
    pip
  ];

}
