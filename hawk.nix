{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/aeza.nix ./mounts/hawk.nix ./common.nix ./lang/en.nix ];

  virtualisation.oci-containers.containers = {
    uptime-kuma = {
      image = "louislam/uptime-kuma:1";
      ports = [ "3001:3001" ];
      volumes = [ "/var/lib/uptime-kuma:/app/data" ];
    };
  };

  age.secrets.cloudflare-credentials.file =
    ./secrets/cloudflare-credentials.age;
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "averyanalex@gmail.com";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflare-credentials.path;
    };
    certs = {
      "averyan.ru" = { extraDomainNames = [ "*.averyan.ru" ]; };
      "memefinder.ru" = { extraDomainNames = [ "*.memefinder.ru" ]; };
      "linuxguides.ru" = { extraDomainNames = [ "*.linuxguides.ru" ]; };
      "highterum.ru" = { extraDomainNames = [ "*.highterum.ru" ]; };
    };
  };

  boot.kernel.sysctl = {
    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;
  };

  services.openssh.ports = [ 22200 ];

  networking = {
    hostName = "hawk";

    defaultGateway = {
      address = "10.0.0.1";
      interface = "ens3";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      ens3 = {
        ipv4 = {
          addresses = [{
            address = "185.112.83.20";
            prefixLength = 32;
          }];
        };
      };
    };
  };
}
