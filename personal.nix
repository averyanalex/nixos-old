{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/personal.nix ./common.nix ./lang/en.nix ];

  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /tank 192.168.3.18(rw,async,all_squash,root_squash,anonuid=1000,anongid=100)
  '';

  virtualisation.docker.enable = true;

  networking = {
    hostName = "personal";
    id = 105;

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.3.12";
            prefixLength = 24;
          }];
          routes = [{
            address = "185.112.83.20";
            prefixLength = 32;
            via = "192.168.3.1";
          }];
        };
      };
    };
  };

  age.secrets.wg-key.file = ./secrets/personal-wg-key.age;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.8.7.105/32" ];
      privateKeyFile = config.age.secrets.wg-key.path;
      peers = [{
        publicKey = "DIdKXZJf6dfSLabXizF9omKelDCxRGERj6mSR2b2M34=";
        endpoint = "185.112.83.20:51820";
        persistentKeepalive = 25;
        allowedIPs = [ "10.8.7.1/32" "0.0.0.0/0" ];
      }];
    };
  };
}
