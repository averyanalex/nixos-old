{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6f802dce-a57f-4363-8e15-ea2f1c3cfa90";
    fsType = "ext4";
    options = [ "discard" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C739-BFD6";
    fsType = "vfat";
  };
}
