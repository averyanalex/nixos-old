{ config, pkgs, ... }:

{
  imports = [ ./hardware/whale.nix ./common.nix ./lang/en.nix ];

  networking.hostName = "whale";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
}
