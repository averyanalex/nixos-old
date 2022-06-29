{ config, lib, pkgs, ... }:

with lib;

let cfg = config.networking.hawk-wg;
in {
  options.networking.hawk-wg = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to connect to hawk.
      '';
    };
    internet = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Access Internet through hawk.
      '';
    };
    gatewayInterface = mkOption {
      type = types.str;
      default = "enp6s18";
      description = ''
        Interface to access gateway.
      '';
    };
    gatewayIp = mkOption {
      type = types.str;
      default = "192.168.3.1";
      description = ''
        IP of gateway.
      '';
    };
    ipv4 = mkOption {
      type = types.str;
      example = "10.8.7.150";
      description = ''
        IPv4 address in network.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.wireguard.loadAgeKey = true;
    networking.wireguard.interfaces = {
      wghawk0 = {
        ips = [ "${cfg.ipv4}/32" ];
        privateKeyFile = config.age.secrets.wg-key.path;
        peers = [{
          publicKey = "DIdKXZJf6dfSLabXizF9omKelDCxRGERj6mSR2b2M34=";
          endpoint = "185.112.83.20:51820";
          persistentKeepalive = 25;
          allowedIPs = [ "10.8.7.0/24" (mkIf cfg.internet "0.0.0.0/0") ];
        }];
      };
    };
    networking.interfaces.${cfg.gatewayInterface}.ipv4.routes =
      mkIf cfg.internet [{
        address = "185.112.83.20";
        prefixLength = 32;
        via = cfg.gatewayIp;
      }];
  };
}
