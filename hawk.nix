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
    blog = {
      image = "cr.averyan.ru/averyanalex/blog:edge";
      extraOptions = [ "--network=host" ];
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
        http3 = true;
        kTLS = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://localhost:3001";
        locations."/".proxyWebsockets = true;
      };
      "memefinder.ru" = {
        forceSSL = true;
        useACMEHost = "memefinder.ru";
        locations."/".proxyPass = "http://10.8.7.101:3010/";
        locations."/api/".proxyPass = "http://10.8.7.101:3020/";
        locations."/api/static/".proxyPass = "http://10.8.7.101:3030/";
        locations."/".proxyWebsockets = true;
        locations."/api/".proxyWebsockets = true;
      };
      "ptero.frsqr.xyz" = {
        forceSSL = true;
        useACMEHost = "frsqr.xyz";
        locations."/".proxyPass = "http://10.8.7.101:8055/";
        locations."/".proxyWebsockets = true;
      };
      "whale-public-wings.frsqr.xyz" = {
        forceSSL = true;
        useACMEHost = "frsqr.xyz";
        locations."/".proxyPass = "http://10.8.7.109:443/";
        locations."/".proxyWebsockets = true;
      };
      "git.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://10.8.7.101:8095/";
        locations."/".proxyWebsockets = true;
      };
      "cr.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://10.8.7.101:5050/";
      };
      "bw.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://10.8.7.101:4038/";
        locations."/".proxyWebsockets = true;
      };
      "prism.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://10.8.7.105:2342/";
        locations."/".proxyWebsockets = true;
      };
      "averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://localhost:9264";
        locations."/_matrix/".proxyPass = "http://10.8.7.101:5056";
        locations."/_matrix/".proxyWebsockets = true;
        locations."/_synapse/".proxyPass = "http://10.8.7.101:5056";
        locations."/_synapse/".proxyWebsockets = true;
      };
      "pve.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "https://10.8.7.99:8006";
        locations."/".proxyWebsockets = true;
      };
      "matomo.frsqr.xyz" = {
        forceSSL = true;
        useACMEHost = "frsqr.xyz";
        locations."/".proxyPass = "http://10.8.7.101:9748/";
        locations."/".proxyWebsockets = true;
      };
      "api.firesquare.ru" = {
        forceSSL = true;
        useACMEHost = "firesquare.ru";
        locations."/".proxyPass = "http://10.8.7.104:8173/";
        locations."/".proxyWebsockets = true;
      };
      "matrix-federation.averyan.ru" = {
        serverName = "averyan.ru";
        onlySSL = true;
        useACMEHost = "averyan.ru";
        listen = [
          {
            addr = "[::0]";
            port = 8448;
            ssl = true;
          }
          {
            addr = "0.0.0.0";
            port = 8448;
            ssl = true;
          }
        ];
        locations."/".proxyPass = "http://10.8.7.101:5056";
        locations."/".proxyWebsockets = true;
      };
      "ipfs.averyan.ru" = {
        forceSSL = true;
        useACMEHost = "averyan.ru";
        locations."/".proxyPass = "http://10.8.7.101:8386";
      };
    };
  };

  age.secrets.wg-key.file = ./secrets/hawk-wg-key.age;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.8.7.1/32" ];
      listenPort = 51820;
      privateKeyFile = config.age.secrets.wg-key.path;
      peers = [
        {
          publicKey = "b4dRf61Z5XhVXFMjd1Vzhshwc5J4WlNEZJo2+ZKpslM=";
          allowedIPs = [ "10.8.7.2/32" ];
        }
        {
          publicKey = "eAW4jpiWQx08+9AqDZg2F6ca0vGfUdAWkhR7n3B3wXg=";
          allowedIPs = [ "10.8.7.99/32" ];
        }
        {
          publicKey = "MoMpwHx57KWsy44DAdiRxW75x+R+gRo3SJlEI3gzN0Q=";
          allowedIPs = [ "10.8.7.101/32" ];
        }
        {
          publicKey = "xvxr9tv5ou6UavXLAnIIhGo9rHwipgcz522ky5ainSg=";
          allowedIPs = [ "10.8.7.104/32" ];
        }
        {
          publicKey = "uPn+dOrj6M0ebtGC5hlJY5FvBiiycqjfEEy6lsRJRRE=";
          allowedIPs = [ "10.8.7.105/32" ];
        }
        {
          publicKey = "6ddIn1u1JicddhDcTru9XN2OCn+c4TJVzH/UzBDF2wI=";
          allowedIPs = [ "10.8.7.109/32" ];
        }
      ];
    };
    wg1 = {
      ips = [ "10.17.1.1/32" ];
      listenPort = 51821;
      privateKeyFile = config.age.secrets.wg-key.path;
      peers = [
        {
          publicKey = "JYXwHp+VhLPjEwgvDNjCE8fjxiaY4csdUeX7q3G4dxI="; # pocof3
          allowedIPs = [ "10.17.1.10/32" ];
        }
        {
          publicKey = "ZrAj9S0OM0AeuomDy0D9V7YzX8bk+SVlioFmky+QanE="; # skordrey
          allowedIPs = [ "10.17.2.81/32" ];
        }
      ];
    };
  };

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    config = {
      Listen = [ "tls://0.0.0.0:8362" ];
      Peers = [
        "tls://ygg.loskiq.ru:17314"
        "tls://kazi.peer.cofob.ru:18001"
        "tls://yggno.de:18227"
        "tls://box.paulll.cc:13338"
      ];
      IfName = "ygg0";
    };
  };

  users.users.nginx.extraGroups = [ "acme" ];

  age.secrets.cloudflare-credentials.file =
    ./secrets/cloudflare-credentials.age;
  age.secrets.cf-creds-frsqr.file = ./secrets/cf-creds-frsqr.age;

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
      "highterum.ru" = { extraDomainNames = [ "*.highterum.ru" ]; };
      "frsqr.xyz" = {
        extraDomainNames = [ "*.frsqr.xyz" ];
        email = "cofob@riseup.net";
        credentialsFile = config.age.secrets.cf-creds-frsqr.path;
      };
      "firesquare.ru" = {
        extraDomainNames = [ "*.firesquare.ru" ];
        email = "cofob@riseup.net";
        credentialsFile = config.age.secrets.cf-creds-frsqr.path;
      };
    };
  };

  boot.kernel.sysctl = {
    # Enable forwarding
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;

    # By default, not automatically configure any IPv6 addresses.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.all.autoconf" = 0;
    "net.ipv6.conf.all.use_tempaddr" = 0;
  };

  networking = {
    hostName = "hawk";
    id = 200;

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
          chain output {
            type filter hook output priority 100;
            accept
          }

          chain input {
            type filter hook input priority 0;

            ct state invalid counter drop comment "drop invalid packets"

            iifname lo counter accept comment "accept any localhost traffic"

            tcp dport 22200 counter accept comment "ssh"
            udp dport 443 counter accept comment "quic"
            tcp dport { 80, 443, 8448 } counter accept comment "http"

            udp dport 51820 counter accept comment "wg0"
            udp dport 51821 counter accept comment "wg1"

            tcp dport 8362 counter accept comment "yggdrasil"

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
            iifname { "wg0", "wg1" } oifname "ens3" counter accept comment "lan to wan"

            # allow established WAN to return
            iifname "ens3" oifname { "wg0", "wg1" } ct state { established, related } counter accept comment "allow established back to LANs"

            # count and drop any other traffic
            counter drop
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
            ip daddr 185.112.83.20 tcp dport { 22, 22101 } dnat to 10.8.7.101
            ip daddr 185.112.83.20 tcp dport { 25, 143, 465, 587, 993 } dnat to 10.8.7.101 comment "mail"

            ip daddr 185.112.83.20 tcp dport 22103 dnat to 10.8.7.2

            ip daddr 185.112.83.20 tcp dport { 22104, 25565, 25566 } dnat to 10.8.7.104 comment "minecraft"

            ip daddr 185.112.83.20 tcp dport { 4001, 9096, 9093 } dnat to 10.8.7.101 comment "ipfs tcp"
            ip daddr 185.112.83.20 udp dport { 4001, 9096, 9093 } dnat to 10.8.7.101 comment "ipfs udp"

            ip daddr 185.112.83.20 tcp dport { 22105 } dnat to 10.8.7.105 comment "personal"

            ip daddr 185.112.83.20 tcp dport { 22109, 2245 } dnat to 10.8.7.109 comment "hosting"
            ip daddr 185.112.83.20 tcp dport 35560-35575 dnat to 10.8.7.109 comment "hosting-servers-tcp"
            ip daddr 185.112.83.20 udp dport 35560-35575 dnat to 10.8.7.109 comment "hosting-servers-udp"
          }

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
