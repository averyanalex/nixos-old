{ config, pkgs, ... }:

{
  imports = [
    ./hardware/alligator.nix
    ./mounts/alligator.nix
    ./common.nix
    ./lang/ru.nix

    ./pipewire.nix
  ];

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/.config";
    NIXOS_OZONE_WL = "1";
  };

  users.users.alex.extraGroups = [ "video" ];
  programs.light.enable = true;

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
