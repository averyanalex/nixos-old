{ config, pkgs, lib, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/highterum.nix ./common.nix ./lang/en.nix ];

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

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "zerotierone" ];
  services.zerotierone.enable = true;

  networking = {
    hostName = "highterum";
    id = 104;

    hawk-wg = {
      enable = true;
      gatewayIp = "192.168.20.1";
      ipv4 = "10.8.7.104";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.20.14";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
