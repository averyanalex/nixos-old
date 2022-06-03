{ args, config, lib, pkgs, ... }:

{
  nix = {
    useSandbox = true;
    autoOptimiseStore = true;
    readOnlyStore = true;
    allowedUsers = [ "@wheel" ];
    trustedUsers = [ "@wheel" ];
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d --max-freed $((64 * 1024**3))";
    };
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  system = {
    stateVersion = "22.05";
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      flake = "github:averyanalex/nixos";
      dates = "daily";
    };
  };

  environment.systemPackages = [ pkgs.htop pkgs.ncdu pkgs.micro ];
  environment.shellAliases = {
    nixupd = ''
      sudo rm -rf /root/.cache && sudo nixos-rebuild switch --flake "github:averyanalex/nixos"'';
  };

  services.fstrim.enable = true;

  age.secrets.password-alex.file = ./secrets/password/alex.age;
  users = {
    mutableUsers = false;
    users.alex = {
      isNormalUser = true;
      description = "Alexander Averyanov";
      extraGroups = [ "wheel" ];
      uid = 1000;
      passwordFile = config.age.secrets.password-alex.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINF5KDy1T6Z+RlDb+Io3g1uSZ46rhBxhNE39YlG3GPFM averyanalex@gmail.com"
      ];
    };
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  networking.firewall.enable = false;
  networking.useDHCP = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Moscow";
}
