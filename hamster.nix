{ config, pkgs, ... }:

{
  imports = [
    ./hardware/lenovo.nix
    ./mounts/hamster.nix
    ./common.nix
    ./lang/ru.nix

    ./swaysupport.nix
  ];

  boot.kernelPackages = pkgs.unstable.linuxKernel.packages.linux_xanmod_tt;

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  services.blueman.enable = true;

  services.ipfs = {
    enable = true;
    localDiscovery = true;
    enableGC = true;
    autoMount = true;
    emptyRepo = true;
  };

  services.syncthing.enable = true;

  hardware.rtl-sdr.enable = true;
  users.users.alex.extraGroups = [ "plugdev" ];

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

  age.secrets.nebula-ca.file = ./secrets/nebula/ca-crt.age;
  age.secrets.nebula-key.file = ./secrets/nebula/${config.networking.hostName}-key.age;
  age.secrets.nebula-crt.file = ./secrets/nebula/${config.networking.hostName}-crt.age;
  services.nebula.networks.global = {
    key = config.age.secrets.nebula-key.path;
    cert = config.age.secrets.nebula-crt.path;
    ca = config.age.secrets.nebula-ca.path;
    lighthouses = [ "10.3.7.10" ];
    staticHostMap = {
      "10.3.7.10" = [
        "185.112.83.178:4242"
      ];
    };
    firewall = {
      inbound = [{
        host = "any";
        port = "any";
        proto = "any";
      }];
      outbound = [{
        host = "any";
        port = "any";
        proto = "any";
      }];
    };
  };

  networking = {
    hostName = "hamster";
    id = 61;
    networkmanager.enable = true;
  };
}
