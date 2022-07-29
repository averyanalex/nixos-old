{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/hosting.nix ./common.nix ./lang/en.nix ];

  networking = {
    hostName = "hosting";
    id = 109;

    # hawk-wg = {
    #   enable = true;
    #   gatewayIp = "192.168.20.1";
    #   ipv4 = "10.8.7.102";
    # };

    defaultGateway = {
      address = "192.168.20.1";
      interface = "enp6s18";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.20.19";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
