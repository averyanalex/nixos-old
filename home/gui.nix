{ config, pkgs, lib, ... }:

{
  imports = [ ./sway.nix ./apps.nix ./dev.nix ];

  services.mpd = {
    enable = true;
    musicDirectory = "/home/alex/Music";
  };
}
