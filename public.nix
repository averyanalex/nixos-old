{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/public.nix ./common.nix ./lang/en.nix ];

  services.openssh.ports = [ 22101 ];

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "daily";

  environment.systemPackages = [ pkgs.docker-compose_2 ];
  environment.shellAliases = { dc = "docker compose"; };

  age.secrets.cloudflare-credentials.file =
    ./secrets/cloudflare-credentials.age;
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "averyanalex@gmail.com";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare-credentials.path;
    };
    certs."averyan.ru".extraDomainNames = [ "*.averyan.ru" ];
  };

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
