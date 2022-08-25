{ config, pkgs, lib, ... }:

{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    libreoffice-fresh
    unstable.tdesktop
    unstable.element-desktop

    remmina # rdp

    qbittorrent
    mpv

    # games
    polymc

    cantata
  ];
}
