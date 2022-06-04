{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/06f5e119-0acb-4a89-ba70-2a9abc59ebe6";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F335-1EBD";
    fsType = "vfat";
  };
}
