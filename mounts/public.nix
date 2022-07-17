{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7c0b2781-e79b-42bb-892e-a55162147816";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/tank" = {
    device = "/dev/disk/by-uuid/003b90f5-6f00-4283-88bc-e06e1def62c2";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F887-EE08";
    fsType = "vfat";
  };
}
