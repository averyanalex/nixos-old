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

  networking = {
    hostName = "hamster";
    id = 61;
    networkmanager.enable = true;
  };
}
