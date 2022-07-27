{ config, pkgs, lib, ... }:

{
  imports = [ ./sway.nix ./apps.nix ./dev.nix ];

  home.packages = with pkgs; [
    cantata
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "/home/alex/Music";
  };
}
