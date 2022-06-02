{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/router.nix ./common.nix ./lang/en.nix ];

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

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    config = {
      Listen = [ "tcp://0.0.0.0:5353" ];
      IfName = "ygg0";
    };
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

            ct state invalid counter drop comment "drop invalid packets"

            iifname lo counter accept comment "accept any localhost traffic"

            tcp dport 22100 counter accept comment "ssh"
            tcp dport { 80, 443 } counter accept comment "http"
            tcp dport 5353 counter accept comment "yggdrasil public peer"

            iifname {
              "enp6s19",
            } counter accept comment "allow access from lan"

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

            # enable flow offloading for better throughput
            # ip protocol { tcp, udp } flow offload @f

            ct status dnat counter accept comment "allow dnat forwarding"

            # allow trusted network WAN access
            iifname { "enp6s19", "vm40" } oifname "enp6s18" counter accept comment "Allow trusted LAN to WAN"

            # allow established WAN to return
            iifname "enp6s18" oifname { "enp6s19", "vm40" } ct state { established, related } counter accept comment "allow established back to LANs"

            # count and drop any other traffic
            counter drop
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            tcp dport 22101 dnat to 192.168.40.2
          }

          # setup NAT masquerading on the enp6s18 interface
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            ip daddr 192.168.40.2 masquerade
            oifname "enp6s18" masquerade
          }
        }
      '';
    };

    vlans = {
      vm40 = {
        id = 40;
        interface = "enp6s20";
      };
    };

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.3.2";
            prefixLength = 32;
          }];
          routes = [{
            address = "192.168.3.3";
            prefixLength = 32;
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
      vm40 = {
        ipv4 = {
          addresses = [{
            address = "192.168.40.1";
            prefixLength = 24;
          }];
        };
      };
    };
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "vm40" ];
    extraConfig = ''
      option domain-name-servers 8.8.8.8, 1.1.1.1;
      option subnet-mask 255.255.255.0;
      subnet 192.168.40.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.40.255;
        option routers 192.168.40.1;
        interface vm40;
        range 192.168.40.100 192.168.40.254;
      }
    '';
  };
}
