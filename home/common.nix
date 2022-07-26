{ config, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home = {
    username = "alex";
    homeDirectory = "/home/alex";
    stateVersion = "22.05";
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };

  home.packages = with pkgs; [
    gnupg
  ];
}
