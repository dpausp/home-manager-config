#!/usr/bin/env bash
# Standalone Home Manager build script

set -e

echo "Building minimal home-manager config..."

# Create temporary build directory
BUILD_DIR=$(mktemp -d)
echo "Using build dir: $BUILD_DIR"

# Copy files
cp home-minimal.nix "$BUILD_DIR/"
cp -r modules "$BUILD_DIR/"

cd "$BUILD_DIR"

# Create minimal flake.nix
cat > flake.nix << 'EOF'
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs }: {
    homeConfigurations = 
    let
      system = if builtins.currentSystem == "aarch64-darwin" then "aarch64-darwin" else "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      minimal = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home-minimal.nix ];
      };
    };
  };
}
EOF

echo "Building configuration..."
nix build .#homeConfigurations.minimal.activationPackage --no-link

echo "✓ Build successful!"
echo "To activate: home-manager switch --flake $BUILD_DIR#minimal"