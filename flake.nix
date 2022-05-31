{
  description = "AveryanAlex's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }:
    let overlay-unstable = final: prev: { };
    in {
      nixosConfigurations = {
        whale = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, ... }: {
              nixpkgs.overlays = [ overlay-unstable ];
            })
            ./whale.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/alex.nix;
            }
          ];
        };
      };
    };
}
