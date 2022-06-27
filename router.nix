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

  age.secrets.wg-key.file = ./secrets/router-wg-key.age;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.8.7.2/32" ];
      privateKeyFile = config.age.secrets.wg-key.path;
      peers = [{
        publicKey = "DIdKXZJf6dfSLabXizF9omKelDCxRGERj6mSR2b2M34=";
        endpoint = "185.112.83.20:51820";
        persistentKeepalive = 25;
        allowedIPs = [ "10.8.7.1/32" ];
      }];
    };
  };

  networking = {
    hostName = "router";

    defaultGateway = {
      address = "192.168.3.3";
      interface = "enp6s19";
    }

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

            tcp dport 22100 counter accept comment "ssh"

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
            iifname { "enp6s19", "vm40", "vm43", "vm44" } oifname { "wg0", "enp6s19" } counter accept comment "Allow trusted LAN to WAN"

            # allow established WAN to return
            iifname { "wg0", "enp6s19" } oifname { "enp6s19", "vm40", "vm43", "vm44" } ct state { established, related } counter accept comment "allow established back to LANs"

            # count and drop any other traffic
            counter drop
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority dstnat; policy accept;
          }

          # setup NAT masquerading on the enp6s18 interface
          chain postrouting {
            type nat hook postrouting priority srcnat; policy accept;
            oifname { "wg0", "enp6s19" } masquerade
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
}
