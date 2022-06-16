{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/15f78e17-1039-4aad-b2e9-431cb1a49e01";
    fsType = "ext4";
    options = [ "discard" ];
  };
}
