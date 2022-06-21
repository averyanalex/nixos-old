{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a4eafbc3-0e0e-4126-aeea-3faf1f3459cc";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/16E2-004F";
    fsType = "vfat";
  };
}
