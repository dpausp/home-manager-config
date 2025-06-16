{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs, nixpkgs-unstable, devenv }: {
    homeConfigurations = 
    let
      system = "x86_64-linux";

      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      ts = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit pkgs-unstable home-manager nixpkgs nixpkgs-unstable devenv;
        };
        inherit pkgs;
        modules = [
          ./host.nix"
        ];
      };
    };
  };
}
