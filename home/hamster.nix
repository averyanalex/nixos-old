{ config, pkgs, lib, ... }:

{
  imports = [ ./common.nix ./gui.nix ];

  home.packages = with pkgs; [
    gqrx # sdr
  ];
}
