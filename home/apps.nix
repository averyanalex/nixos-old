{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    libreoffice-fresh
    unstable.brave
    unstable.tdesktop
    element-desktop

    remmina # rdp
  ];
}
