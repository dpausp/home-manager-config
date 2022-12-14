{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    #hm-config.url = "path:./home-manager-config";
    #hm-config.url = "github:dpausp/home-manager-config";
  };

  outputs = inputs: {
    homeConfigurations = 
    let
      system = "x86_64-linux";
      homeDirectory = "/home/ts";
      username = "ts";
      stateVersion = "22.11";
      inherit (inputs) hm-config nixpkgs nixpkgs-unstable;
      pkgs = nixpkgs.legacyPackages.${system};
    in 
    {
      ts = inputs.home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = {
          inherit nixpkgs nixpkgs-unstable;
        };
        inherit pkgs;
        modules = [
          "${hm-config}/host.nix"
          {
            home = {
              inherit username homeDirectory stateVersion;
            };
          }
        ];
      };
    };
  };
}
