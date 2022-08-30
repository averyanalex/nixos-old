{ config, pkgs, ... }:

{
  imports = [
    ./hardware/alligator.nix
    ./mounts/alligator.nix
    ./common.nix
    ./lang/ru.nix

    ./swaysupport.nix
  ];

  boot.kernelPackages = pkgs.unstable.linuxKernel.packages.linux_xanmod_tt;

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  virtualisation.docker.enable = true;

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    config = {
      Peers = [
        "tls://ygg.averyan.ru:8362"
      ];
      IfName = "ygg0";
    };
  };

  services.syncthing.enable = true;
  services.ipfs = {
    enable = true;
    localDiscovery = true;
    enableGC = true;
    autoMount = true;
    emptyRepo = true;
  };

  networking = {
    hostName = "alligator";
    id = 60;

    defaultGateway = {
      address = "192.168.3.1";
      interface = "enp10s0";
    };

    interfaces.enp10s0 = {
      ipv4 = {
        addresses = [{
          address = "192.168.3.60";
          prefixLength = 24;
        }];
      };
    };
  };
}
