{ config, pkgs, ... }:

{
  imports = [ ./hardware/router.nix ./common.nix ./lang/en.nix ];

  networking = {
    hostName = "router";
    defaultGateway = {
      address = "192.168.1.1";
      interface = "enp6s18";
    };

    interfaces.enp6s18 = {
      ipv4 = {
        addresses = [
          {
            address = "192.168.1.1";
            prefixLength = 24;
          }
          {
            address = "192.168.3.1";
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
