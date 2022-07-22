{ config, pkgs, ... }:

{
  imports = [
    ./hardware/alligator.nix
    ./mounts/alligator.nix
    ./common.nix
    ./lang/ru.nix

    ./pipewire.nix
  ];

  services.getty.autologinUser = "alex";

  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  virtualisation.docker.enable = true;

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

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

  fonts.enableDefaultFonts = true;
  programs.dconf.enable = true;

  users.users.alex.extraGroups = [ "video" ];
  programs.light.enable = true;

  age.secrets.wayvnc = {
    file = ./secrets/wayvnc.age;
    path = "/home/alex/.config/wayvnc/config";
    owner = "alex";
  };
  age.secrets.wayvnc-cert = {
    file = ./secrets/wayvnc-cert.age;
    path = "/home/alex/.config/wayvnc/cert.pem";
    owner = "alex";
  };
  age.secrets.wayvnc-key = {
    file = ./secrets/wayvnc-key.age;
    path = "/home/alex/.config/wayvnc/key.pem";
    owner = "alex";
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
