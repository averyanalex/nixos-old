{ config, lib, pkgs, ... }:

{
  config = {
    services.openssh = {
      enable = true;
      ports = [ (22000 + config.networking.id) ];
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
    environment.systemPackages = [ pkgs.mosh ];
  };
}
