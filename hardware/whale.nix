{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules =
    [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9850ea44-d9ce-42b7-a392-10868e13ff36";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/9850ea44-d9ce-42b7-a392-10868e13ff36";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/9850ea44-d9ce-42b7-a392-10868e13ff36";
    fsType = "btrfs";
    options = [ "subvol=@var" ];
  };

  fileSystems."/var/cache" = {
    device = "/dev/disk/by-uuid/9850ea44-d9ce-42b7-a392-10868e13ff36";
    fsType = "btrfs";
    options = [ "subvol=@cache" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/disk/by-uuid/9850ea44-d9ce-42b7-a392-10868e13ff36";
    fsType = "btrfs";
    options = [ "subvol=@logs" ];
  };

  fileSystems."/nix/store" = {
    device = "/dev/disk/by-uuid/9850ea44-d9ce-42b7-a392-10868e13ff36";
    fsType = "btrfs";
    options = [ "subvol=@store" ];
  };

  fileSystems."/var/lib/docker" = {
    device = "/dev/disk/by-uuid/9850ea44-d9ce-42b7-a392-10868e13ff36";
    fsType = "btrfs";
    options = [ "subvol=@docker" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C97B-FEAC";
    fsType = "vfat";
  };

  swapDevices = [ ];

  hardware.enableRedistributableFirmware = true;

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
