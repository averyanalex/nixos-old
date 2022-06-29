{ config, lib, pkgs, ... }:

with lib;

{
  options.networking.id = mkOption {
    type = types.int;
    description = ''
      Machine ID (1-999).
    '';
  };

  config = {
    assertions = [{
      assertion = config.networking.id >= 1 && config.networking.id <= 999;
      message = "ID must be 1-999";
    }];
  };
}
