{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    devenv.url = "github:cachix/devenv";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hm-config.url = "path:/Users/ts/git/hm-config";
  };

  outputs = { self, home-manager, hm-config, nixpkgs, nixpkgs-stable, devenv }: {
    homeConfigurations = 
    let
      system = "aarch64-darwin";

      pkgs-stable = nixpkgs-stable.legacyPackages.${system};
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      tobiast = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit pkgs-stable home-manager nixpkgs nixpkgs-stable devenv;
        };
        inherit pkgs;
        modules = [ 
          "${hm-config}/mac_tobiast.nix"
        ];
      };

      rovodev = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit pkgs-stable home-manager nixpkgs nixpkgs-stable devenv;
        };
        inherit pkgs;
        modules = [ 
          "${hm-config}/mac_kiagents.nix"
        ];
      };
    };
  };
}
