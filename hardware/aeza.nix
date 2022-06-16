{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  services.qemuGuest.enable = true;

  boot.initrd.availableKernelModules =
    [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];

  hardware.enableRedistributableFirmware = false;
  hardware.cpu.amd.updateMicrocode = false;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
}
