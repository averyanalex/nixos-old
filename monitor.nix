{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/monitor.nix ./common.nix ./lang/en.nix ];

  networking = {
    hostName = "monitor";
    id = 102;

    hawk-wg = {
      enable = true;
      gatewayIp = "192.168.20.1";
      ipv4 = "10.8.7.102";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.20.12";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
