{
  description = "AveryanAlex's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, rust-overlay, agenix }:
    {
      nixosConfigurations = {
        router = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./router.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/headless.nix;
            }
          ];
        };
        hawk = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hawk.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/headless.nix;
            }
          ];
        };
        public = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./public.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/headless.nix;
            }
          ];
        };
        monitor = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./monitor.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/headless.nix;
            }
          ];
        };
        runner = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./runner.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/headless.nix;
            }
          ];
        };
        highterum = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./highterum.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/headless.nix;
            }
          ];
        };
        personal = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./personal.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/headless.nix;
            }
          ];
        };
        ferret = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./ferret.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alexey = import ./home/alexey.nix;
            }
          ];
        };
        alligator = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, ... }:
              let
                overlay-unstable = final: prev: {
                  unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
                };
              in
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
            })
            ./alligator.nix
            agenix.nixosModule
            {
              environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/alligator.nix;
            }
          ];
        };
        hamster = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ({ config, pkgs, ... }:
              let
                overlay-unstable = final: prev: {
                  unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
                };
              in
              {
                nixpkgs.overlays = [ overlay-unstable ];
              }
            )
            ({ pkgs, ... }: {
              nixpkgs.overlays = [ rust-overlay.overlays.default ];
            })
            ./hamster.nix
            agenix.nixosModule
            {
              environment.systemPackages = [ agenix.defaultPackage.x86_64-linux ];
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/hamster.nix;
            }
          ];
        };
      };
    };
}
