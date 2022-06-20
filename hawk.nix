{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/aeza.nix ./mounts/hawk.nix ./common.nix ./lang/en.nix ];

  virtualisation.oci-containers.containers = {
    uptime-kuma = {
      image = "louislam/uptime-kuma:1";
      extraOptions = [ "--network=host" ];
      volumes = [ "/var/lib/uptime-kuma:/app/data" ];
    };
  };

  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    clientMaxBodySize = "8g";
    virtualHosts = {
      "status.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://localhost:3001";
        locations."/".proxyWebsockets = true;
      };
    };
  };

  age.secrets.wg-key.file = ./secrets/hawk-wg-key.age;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.8.7.1/32" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wg-key.path;
      peers = [{
        publicKey = "sSec5CDR9rgAcgcg16iAnNT/zbktZFKPMjEOuuXv7l0=";
        allowedIPs = [ "10.8.7.16/32" ];
      }];
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

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
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          # allow all outgoing connections
          chain output {
            type filter hook output priority 100;
            accept
          }

          chain input {
            type filter hook input priority 0;

            ct state invalid counter drop comment "drop invalid packets"

            iifname lo counter accept comment "accept any localhost traffic"

            tcp dport 22200 counter accept comment "ssh"
            tcp dport { 80, 443 } counter accept comment "http"
            udp dport 51820 counter accept comment "wireguard"

            # ICMP
            ip6 nexthdr icmpv6 icmpv6 type {
              destination-unreachable,
              packet-too-big,
              time-exceeded,
              parameter-problem,
              nd-router-advert,
              nd-neighbor-solicit,
              nd-neighbor-advert
            } counter accept comment "icmpv6"
            ip protocol icmp icmp type {
              destination-unreachable,
              router-advertisement,
              time-exceeded,
              parameter-problem
            } counter accept comment "icmpv4"

            # ping
            ip6 nexthdr icmpv6 icmpv6 type echo-request counter accept comment "pingv6"
            ip protocol icmp icmp type echo-request counter accept comment "pingv4"

            ct state { established, related } counter accept comment "accept traffic originated from us"

            # count and drop any other traffic
            counter drop
          }

          chain forward {
            type filter hook forward priority 0;

            ct status dnat counter accept comment "allow dnat forwarding"

            # allow trusted network WAN access
            iifname "wg0" oifname "ens3" counter accept comment "lan to wan"

            # allow established WAN to return
            iifname "ens3" oifname "wg0" ct state { established, related } counter accept comment "allow established back to LANs"

            # count and drop any other traffic
            counter drop
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
          }

          # setup NAT masquerading on the ens3 interface
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            oifname "ens3" masquerade
          }
        }
      '';
    };

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
