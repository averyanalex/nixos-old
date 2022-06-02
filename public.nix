{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/public.nix ./common.nix ./lang/en.nix ];

  services.resolved.enable = true;
  networking.nameservers = [ "8.8.8.8" "9.9.9.9" ];

  services.openssh.ports = [ 22101 ];

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "daily";
  environment.systemPackages = [ pkgs.docker-compose_2 ];

  networking = {
    hostName = "public";

    defaultGateway = {
      address = "192.168.40.1";
      interface = "enp6s18";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.40.2";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
