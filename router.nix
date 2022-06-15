{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/router.nix ./common.nix ./lang/en.nix ];

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

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    config = {
      Listen = [ "tcp://0.0.0.0:5353" ];
      Peers = [
        "tls://ygg.loskiq.ru:17314"
        "tls://kazi.peer.cofob.ru:18001"
        "tls://yggno.de:18227"
        "tls://box.paulll.cc:13338"
      ];
      IfName = "ygg0";
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
      "matrix-federation.averyan.ru" = {
        serverName = "averyan.ru";
        onlySSL = true;
        useACMEHost = "averyan.ru";
        listen = [{
          addr = "192.168.3.1";
          port = 8448;
          ssl = true;
        }];
        locations."/".proxyPass = "http://192.168.40.2:5056";
        locations."/".proxyWebsockets = true;
      };
      "matrix-federation.highterum.ru" = {
        serverName = "highterum.ru";
        onlySSL = true;
        useACMEHost = "highterum.ru";
        listen = [{
          addr = "192.168.3.1";
          port = 8448;
          ssl = true;
        }];
        locations."/".proxyPass = "http://192.168.40.2:5057";
        locations."/".proxyWebsockets = true;
      };
      "averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/_matrix/".proxyPass = "http://192.168.40.2:5056";
        locations."/_matrix/".proxyWebsockets = true;
        locations."/_synapse/".proxyPass = "http://192.168.40.2:5056";
        locations."/_synapse/".proxyWebsockets = true;
      };
      "ipfs.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://192.168.40.2:8386";
      };
      "highterum.ru" = {
        forceSSL = true;
        useACMEHost = "highterum.ru";
        locations."/api/".proxyPass = "http://192.168.44.2:8085/";
        locations."/api/".proxyWebsockets = true;

        locations."/_matrix/".proxyPass = "http://192.168.40.2:5057";
        locations."/_matrix/".proxyWebsockets = true;
        locations."/_synapse/".proxyPass = "http://192.168.40.2:5057";
        locations."/_synapse/".proxyWebsockets = true;

        locations."/".proxyPass = "http://192.168.44.2:8086/";
        locations."/".proxyWebsockets = true;
      };
      "pve.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "https://192.168.3.4:8006/";
        locations."/".proxyWebsockets = true;
      };
      "git.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://192.168.40.2:8095/";
        locations."/".proxyWebsockets = true;
      };
      "cr.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://192.168.40.2:5050/";
      };
      "bw.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://192.168.40.2:4038/";
        locations."/".proxyWebsockets = true;
      };
      "ptero.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://192.168.40.2:8055/";
        locations."/".proxyWebsockets = true;
      };
      "memefinder.ru" = {
        forceSSL = true;
        useACMEHost = "memefinder.ru";
        locations."/".proxyPass = "http://192.168.40.2:3010/";
        locations."/api/".proxyPass = "http://192.168.40.2:3020/";
        locations."/api/static/".proxyPass = "http://192.168.40.2:3030/";
        locations."/".proxyWebsockets = true;
        locations."/api/".proxyWebsockets = true;
      };
      "node.highterum.ru" = {
        forceSSL = true;
        useACMEHost = "highterum.ru";
        locations."/".proxyPass = "http://192.168.44.2:8443/";
        locations."/".proxyWebsockets = true;
      };
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  age.secrets.wg-key.file = ./secrets/router-wg-key.age;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "192.168.32.1/24" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wg-key.path;
      peers = [{ # hamster
        publicKey = "NEUT4NBFv+P2EmJmr59IneMpsbma4UpUwu9QsI4jGzE=";
        allowedIPs = [ "192.168.32.10/32" ];
      }];
    };
  };

  networking = {
    hostName = "router";

    defaultGateway = {
      address = "192.168.3.3";
      interface = "enp6s19";
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
            tcp dport 8448 counter accept comment "matrix"
            tcp dport 5353 counter accept comment "yggdrasil public peer"
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

            # enable flow offloading for better throughput
            # ip protocol { tcp, udp } flow offload @f

            ct status dnat counter accept comment "allow dnat forwarding"

            # allow trusted network WAN access
            iifname { "enp6s19", "vm40", "vm43", "vm44" } oifname "enp6s19" counter accept comment "Allow trusted LAN to WAN"

            # allow established WAN to return
            iifname "enp6s19" oifname { "enp6s19", "vm40", "vm43", "vm44" } ct state { established, related } counter accept comment "allow established back to LANs"

            # count and drop any other traffic
            counter drop
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            ip daddr 192.168.3.1 tcp dport { 22, 22101 } dnat to 192.168.40.2
            ip daddr 192.168.3.1 tcp dport { 25, 143, 465, 587, 993 } dnat to 192.168.40.2
            ip daddr 192.168.3.1 tcp dport 22103 dnat to 192.168.43.2
            ip daddr 192.168.3.1 tcp dport { 22104, 5432, 3306 } dnat to 192.168.44.2
            ip daddr 192.168.3.1 tcp dport { 4001, 9096 } dnat to 192.168.40.2
            ip daddr 192.168.3.1 udp dport { 4001, 9096 } dnat to 192.168.40.2
          }

          # setup NAT masquerading on the enp6s18 interface
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            oifname "enp6s19" masquerade
          }
        }
      '';
    };

    vlans = {
      vm40 = {
        id = 40;
        interface = "enp6s20";
      };
      vm43 = {
        id = 43;
        interface = "enp6s20";
      };
      vm44 = {
        id = 44;
        interface = "enp6s20";
      };
    };

    interfaces = {
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
      vm43 = {
        ipv4 = {
          addresses = [{
            address = "192.168.43.1";
            prefixLength = 24;
          }];
        };
      };
      vm44 = {
        ipv4 = {
          addresses = [{
            address = "192.168.44.1";
            prefixLength = 24;
          }];
        };
      };
    };
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "vm40" "vm43" "vm44" ];
    extraConfig = ''
      option domain-name-servers 8.8.8.8, 1.1.1.1;
      option subnet-mask 255.255.255.0;
      subnet 192.168.40.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.40.255;
        option routers 192.168.40.1;
        interface vm40;
        range 192.168.40.100 192.168.40.254;
      }
      subnet 192.168.43.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.43.255;
        option routers 192.168.43.1;
        interface vm43;
        range 192.168.43.100 192.168.43.254;
      }
      subnet 192.168.44.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.44.255;
        option routers 192.168.44.1;
        interface vm44;
        range 192.168.44.100 192.168.44.254;
      }
    '';
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * * ${pkgs.curl} https://status.frsqr.xyz/api/push/gfpM7BB8iI?status=up&msg=OK&ping="
    ];
  };
}
