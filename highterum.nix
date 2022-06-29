{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/highterum.nix ./common.nix ./lang/en.nix ];

  services.openssh.ports = [ 22104 ];

  virtualisation.docker.enable = true;

  age.secrets.highterum-pgsql.file = ./secrets/highterum-pgsql.age;
  age.secrets.ht-cabinet-api.file = ./secrets/ht-cabinet-api.age;
  age.secrets.docker-registries-root = {
    file = ./secrets/docker-registries-ro.age;
    path = "/root/.docker/config.json";
  };
  age.secrets.docker-registries-alex = {
    file = ./secrets/docker-registries-ro.age;
    path = "/home/alex/.docker/config.json";
    owner = "alex";
  };

  networking = {
    hostName = "highterum";

    hawk-wg = {
      enable = true;
      gatewayIp = "192.168.44.1";
      ipv4 = "10.8.7.104";
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
