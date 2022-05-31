{ config, pkgs, ... }:

{
  imports = [ ./hardware/router.nix ./common.nix ./lang/en.nix ];

  services.qemuGuest.enable = true;

  services.resolved.enable = true;
  networking.nameservers = [ "8.8.8.8" "9.9.9.9" ];

  networking = {
    hostName = "router";

    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp6s18";
    };

    vlans = {
      lan = {
        id = 30;
        interface = "enp6s18";
      };
    };

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.1.84";
            prefixLength = 24;
          }];
        };
      };
      lan = {
        ipv4 = {
          addresses = [{
            address = "192.168.3.1";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
