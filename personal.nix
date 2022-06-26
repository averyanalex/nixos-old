{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/personal.nix ./common.nix ./lang/en.nix ];

  services.openssh.ports = [ 22105 ];

  networking = {
    hostName = "personal";

    defaultGateway = {
      address = "192.168.3.1";
      interface = "enp6s18";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.3.12";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
