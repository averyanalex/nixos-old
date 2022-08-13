{ config, pkgs, lib, ... }:

{
  imports = [ ./firefox.nix ];

  home.packages = with pkgs; [
    libreoffice-fresh
    unstable.brave
    unstable.tdesktop
    element-desktop

    remmina # rdp

    qbittorrent
    mpv

    # games
    polymc
  ];
}
