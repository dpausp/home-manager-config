{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs.python3Packages; [
    pkgs.python39
    (pkgs.python310.overrideAttrs (_: { meta.priority = 4; }) )
    (pkgs.python311.overrideAttrs (_: { meta.priority = 3; }) )
    (pkgs.python312.overrideAttrs (_: { meta.priority = 4; }) )
    (black.overridePythonAttrs (_: {
      propagatedBuildInputs = black.propagatedBuildInputs ++ black.optional-dependencies.d;
    }))
    isort
    pkgs.pre-commit
    pip
  ];

}
