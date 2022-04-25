{ config, pkgs, ... }:

{
  imports = [ ./hardware/whale.nix ];

  networking.hostName = "whale";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
