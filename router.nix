{ config, pkgs, ... }:

{
  imports = [ ./hardware/router.nix ./common.nix ./lang/en.nix ];

  services.qemuGuest.enable = true;

  services.resolved.enable = true;
  networking.nameservers = [ "8.8.8.8" "9.9.9.9" ];

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;

    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;
  };

  services.openssh.ports = [ 22100 ];

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "averyanalex@gmail.com";
      dnsProvider = "cloudflare";
      credentialsFile = "/etc/cloudflare-creds";
    };
    certs = { "averyan.ru" = { extraDomainNames = [ "*.averyan.ru" ]; }; };
  };

  services.nginx = {
    enable = true;
    package = pkgs.nginxQuic;
    virtualHosts = {
      "pve.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "https://192.168.3.4:8006";
        locations."/".proxyWebsockets = true;
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  networking = {
    hostName = "router";

    defaultGateway = {
      address = "192.168.3.3";
      interface = "enp6s18";
    };

    nat.enable = false;
    firewall.enable = false;
    nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          # enable flow offloading for better throughput
          # flowtable f {
          #   hook ingress priority 0;
          #   devices = { enp6s18, lan };
          # }

          # allow all outgoing connections
          chain output {
            type filter hook output priority 100;
            accept
          }

          chain input {
            type filter hook input priority 0;

            ct state invalid counter drop comment "drop invalid packages"
            ct state { established, related } counter accept comment "accept traffic originated from us"

            # accept any localhost traffic
            iifname lo accept

            # ICMP
            ip6 nexthdr icmpv6 icmpv6 type {
              destination-unreachable,
              packet-too-big,
              time-exceeded,
              parameter-problem,
              nd-router-advert,
              nd-neighbor-solicit,
              nd-neighbor-advert
            } accept
            ip protocol icmp icmp type {
              destination-unreachable,
              router-advertisement,
              time-exceeded,
              parameter-problem
            } accept

            # ping
            ip6 nexthdr icmpv6 icmpv6 type echo-request accept
            ip protocol icmp icmp type echo-request accept

            # ssh
            tcp dport 22100 accept

            # web
            tcp dport 80 accept
            tcp dport 443 accept

            # allow access from lan
            iifname {
              "enp6s19",
            } accept

            # count and drop any other traffic
            counter drop
          }

          chain forward {
            type filter hook forward priority 0;

            # enable flow offloading for better throughput
            # ip protocol { tcp, udp } flow offload @f

            # allow trusted network WAN access
            iifname {
                    "enp6s19",
            } oifname {
                    "enp6s18",
            } counter accept comment "Allow trusted LAN to WAN"

            # allow established WAN to return
            iifname {
                    "enp6s18",
            } oifname {
                    "enp6s19",
            } ct state { established, related } counter accept comment "allow established back to LANs"

            tcp dport 222 counter accept

            # count and drop any other traffic
            counter drop
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority 0; policy accept;
            tcp dport 222 dnat to 192.168.3.105
          }

          # setup NAT masquerading on the enp6s18 interface
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "enp6s18" masquerade
          }
        }
      '';
    };

    # vlans = {
    #   lan = {
    #     id = 30;
    #     interface = "enp6s18";
    #   };
    # };

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.3.2";
            prefixLength = 24;
          }];
        };
      };
      enp6s19 = {
        ipv4 = {
          addresses = [{
            address = "192.168.3.1";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
