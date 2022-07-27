{ config, pkgs, ... }:

{
  imports = [ ./zsh.nix ];

  programs.home-manager.enable = true;
  home = {
    username = "alex";
    homeDirectory = "/home/alex";
    stateVersion = "22.05";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
  };

  home.packages = with pkgs; [
    gnupg
  ];
}
