{ config, lib, pkgs, ... }:

with lib;

{
  options.networking.wireguard.loadAgeKey = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether to load agenix-encrypted wireguard private key.
    '';
  };

  config = mkIf config.networking.wireguard.loadAgeKey {
    age.secrets.wg-key.file =
      ../secrets/wireguard/${config.networking.hostname}.age;
  };
}
