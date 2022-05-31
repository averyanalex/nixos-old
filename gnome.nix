{ config, pkgs, ... }:

{
  imports = [ ./pipewire.nix ];

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
