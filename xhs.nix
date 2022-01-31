{ config, pkgs, ... }:

{
  imports = [ ./xhs-hardware.nix ];

  networking.hostName = "xeon-homeserver";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
}
