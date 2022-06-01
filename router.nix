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

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "lan" ];
    extraConfig = ''
      option domain-name-servers 8.8.8.8, 1.1.1.1;
      option subnet-mask 255.255.255.0;

      subnet 192.168.3.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.3.255;
        option routers 192.168.3.1;
        interface lan;
        range 192.168.3.100 192.168.3.254;
      }
    '';
  };

  networking = {
    hostName = "router";

    defaultGateway = {
      address = "192.168.1.1";
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
            tcp dport 22 accept

            # allow access from lan
            iifname {
              "lan",
            } accept

            # accept traffic originated from us
            ct state {established, related} accept

            # count and drop any other traffic
            counter drop
          }

          chain forward {
            type filter hook forward priority 0;

            # enable flow offloading for better throughput
            # ip protocol { tcp, udp } flow offload @f

            # allow trusted network WAN access
            iifname {
                    "lan",
            } oifname {
                    "enp6s18",
            } counter accept comment "Allow trusted LAN to WAN"

            # Allow established WAN to return
            iifname {
                    "enp6s18",
            } oifname {
                    "lan",
            } ct state { established, related } counter accept comment "Allow established back to LANs"

            # count and drop any other traffic
            counter drop
          }
        }

        table ip nat {
          chain prerouting {
            type nat hook prerouting priority 0; policy accept;
          }

          # Setup NAT masquerading on the ppp0 interface
          chain postrouting {
            type nat hook postrouting priority 100; policy accept;
            oifname "enp6s18" masquerade
          }
        }
      '';
    };

    vlans = {
      lan = {
        id = 30;
        interface = "enp6s18";
      };
    };

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.1.84";
            prefixLength = 24;
          }];
        };
      };
      lan = {
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
