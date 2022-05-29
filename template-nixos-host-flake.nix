{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    hm-config.url = "github:dpausp/home-manager-config";
  };

  outputs = inputs: {
    homeConfigurations = {
      ts = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/ts";
        username = "ts";
        stateVersion = "22.05";
        configuration.imports = [ 
          "${inputs.hm-config}/host.nix"
        ];
      };
    };
  };
}
