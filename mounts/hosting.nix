{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9ebcf6d9-93c5-45fa-a83e-cc2dd3cfe663";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7BB7-6938";
    fsType = "vfat";
  };
}
