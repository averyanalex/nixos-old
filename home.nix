{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "alex";
    homeDirectory = "/home/alex";
    packages = with pkgs; [ aspell ];
    stateVersion = "21.11";
  };
}
