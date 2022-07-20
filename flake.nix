{
  description = "AveryanAlex's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-22.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, agenix, home-manager }:
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
              home-manager.users.alex = import ./home/alex.nix;
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
              home-manager.users.alex = import ./home/alex.nix;
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
              home-manager.users.alex = import ./home/alex.nix;
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
              home-manager.users.alex = import ./home/alex.nix;
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
              home-manager.users.alex = import ./home/alex.nix;
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
              home-manager.users.alex = import ./home/alex.nix;
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
            # ./unstable.nix
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
            ./alligator.nix
            agenix.nixosModule
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.alex = import ./home/alex-alligator.nix;
            }
          ];
        };
      };
    };
}
