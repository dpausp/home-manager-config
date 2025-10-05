{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs }: {
    homeConfigurations = 
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      minimal = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home-minimal.nix
        ];
      };
    };
  };
}