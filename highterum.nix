{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/highterum.nix ./common.nix ./lang/en.nix ];

  services.openssh.ports = [ 22104 ];

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "daily";

  age.secrets.highterum-pgsql.file = ./secrets/highterum-pgsql.age;
  age.secrets.ht-cabinet-api.file = ./secrets/ht-cabinet-api.age;
  age.secrets.crsrv-token.file = ./secrets/crsrv-token.age;

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    ht-pgsql = {
      image = "postgres:14";
      ports = [ "5432:5432" ];
      volumes = [ "/var/lib/ht-pgsql:/var/lib/postgresql/data" ];
      environmentFiles = [ config.age.secrets.highterum-pgsql.path ];
    };
    ht-cabinet = {
      image = "cr.averyan.ru/highterum/simple-cabinet/web-api";
      ports = [ "8085:8080" ];
      volumes = [
        "/var/lib/ht-cabinet:/app/data"
        "${config.age.secrets.ht-cabinet-api.path}:/app/data/application.properties"
      ];
      login = {
        registry = "https://cr.averyan.ru";
        username = "averyanalex";
        passwordFile = config.age.secrets.crsrv-token.path;
      };
    };
    ht-cabinet-frontend = {
      image = "cr.averyan.ru/highterum/simple-cabinet/frontend-2";
      ports = [ "8086:80" ];
      login = {
        registry = "https://cr.averyan.ru";
        username = "averyanalex";
        passwordFile = config.age.secrets.crsrv-token.path;
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    clientMaxBodySize = "8g";
    virtualHosts = {
      "assets" = {
        serverName = "192.168.44.2:8087";
        listen = [{
          port = 8087;
          addr = "192.168.44.2";
        }];
        locations."/".root = "/var/lib/ht-cabinet/assets";
      };
    };
  };

  networking = {
    hostName = "highterum";

    defaultGateway = {
      address = "192.168.44.1";
      interface = "enp6s18";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.44.2";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
