{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/aeza.nix ./mounts/mole.nix ./common.nix ./lang/en.nix ];

  virtualisation.oci-containers.containers = {
    hackagecompare = {
      image = "louislam/uptime-kuma:1";
      ports = [ "3001:3001" ];
      volumes = [ "/var/lib/uptime-kuma:/app/data" ];
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
    hostName = "mole";

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
