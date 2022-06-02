{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/7c0b2781-e79b-42bb-892e-a55162147816";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F887-EE08";
    fsType = "vfat";
  };
}
