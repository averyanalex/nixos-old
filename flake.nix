{
  description = "AveryanAlex's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager, rust-overlay, nur, agenix }:
    {
      nixosModules = {
        home-headless = import ./home/headless.nix;
      };
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
        hosting = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosting.nix
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
            {
              nixpkgs.overlays = [ nur.overlay ];
            }
            ./alligator.nix
            agenix.nixosModule
            nur.nixosModules.nur
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
            {
              nixpkgs.overlays = [ nur.overlay ];
            }
            ./hamster.nix
            agenix.nixosModule
            nur.nixosModules.nur
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/hamster.nix;
            }
          ];
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = [ agenix.defaultPackage.${system} ];
          buildInputs = [ ];
        };
      });
}
