{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/1a3ad843-ff82-4974-944c-befb04d40bac";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d10cccd2-3bce-46ec-a3b6-faa93e76b03d";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/AEB5-A8EC";
    fsType = "vfat";
  };
}
