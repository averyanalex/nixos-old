{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "alex";
    homeDirectory = "/home/alex";
    stateVersion = "21.11";
  };
}
