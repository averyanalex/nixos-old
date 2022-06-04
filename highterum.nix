{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/highterum.nix ./common.nix ./lang/en.nix ];

  services.openssh.ports = [ 22104 ];

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "daily";

  networking = {
    hostName = "highterum";

    defaultGateway = {
      address = "192.168.44.1";
      interface = "enp6s18";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.44.2";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
