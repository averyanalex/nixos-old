{ config, pkgs, ... }:

{
  imports = [ ./hardware/whale.nix ];

  networking.hostName = "whale";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
}
