{ lib, config, pkgs, ... }:
let
  allDevices = [ "alligator" "hamster" "pocoft" ];
in
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
      hamster.id = "VH7MYCJ-CG6L4IO-M3YSBMF-67S5RVM-PG4MPCH-7K3PNMC-UQPMHPF-RKDWCAN";
      pocoft.id = "4YTG43C-6RYBYZV-V6P24VC-MQWYOBX-QO2FPYC-4AYR3TJ-DQDXZX4-BVPO2AO";
    };
    folders = {
      "/home/alex/Music" = {
        id = "music";
        devices = allDevices;
      };
      "/home/alex/Documents" = {
        id = "documents";
        devices = allDevices;
      };
      "/home/alex/Pictures" = {
        id = "pictures";
        devices = allDevices;
      };
    };
  };
}
