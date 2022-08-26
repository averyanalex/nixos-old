{ lib, config, pkgs, ... }:
{
  config.services.syncthing = lib.mkIf config.services.syncthing.enable {
    user = "alex";
    group = "users";
    dataDir = "/home/alex";
    openDefaultPorts = true;
    devices = {
      alligator = {
        addresses = [
          "tcp://192.168.3.60:22000"
        ];
        id = "RZP5BDL-HVPSCK7-OETCWX7-DLBF33F-D2TFH7K-3JFC6IK-PNJQQGO-2PN44QA";
      };
    };
  };
}
