{ config, pkgs, ... }:

{
  imports = [ ./zsh.nix ./gpg.nix ];

  programs.home-manager.enable = true;

  home = {
    username = "alex";
    homeDirectory = "/home/alex";
    stateVersion = "22.05";
  };
}
