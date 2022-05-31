{ config, pkgs, ... }:

{
  imports = [ ./hardware/whale.nix ./common.nix ./lang/en.nix ];

  networking = {
    hostName = "whale";
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
  };
}
