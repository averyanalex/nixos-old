{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "alexey";
    homeDirectory = "/home/alexey";
    stateVersion = "22.05";
  };
}
