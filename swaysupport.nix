{ config, pkgs, ... }:

{
  imports = [ ./pipewire.nix ];
  services.getty.autologinUser = "alex";

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  services.flatpak.enable = true;

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
}
