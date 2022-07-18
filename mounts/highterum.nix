{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f93819ee-d7d3-49b3-a918-98bfa04637f1";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/tank" = {
    device = "/dev/disk/by-uuid/f1622f78-3fbb-40ab-87d2-0bef30c4515c";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/453A-5406";
    fsType = "vfat";
  };
}
