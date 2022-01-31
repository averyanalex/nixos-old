{ config, lib, pkgs, ... }: {
  nix = {
    package = pkgs.nixFlakes;
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

  nixpkgs.overlays = [
    (final: prev: {
      stdenv = prev.stdenvAdapters.addAttrsToDerivation {
        NIX_CFLAGS_COMPILE = toString (args.NIX_CFLAGS_COMPILE or "") + " -march=tigerlake";
        NIX_CXXFLAGS_COMPILE = toString (args.NIX_CFXXLAGS_COMPILE or "") + " -march=tigerlake";
        NIX_ENFORCE_NO_NATIVE = false;
        preferLocalBuild = true;
      } prev.stdenv;
    })
  ];

  system = {
    stateVersion = "21.11";
    autoUpgrade = {
      enable = true;
      allowReboot = true;
      flake = "github:averyanalex/nixos";
      dates = "daily";
    };
  };

  environment.systemPackages = [ pkgs.compsize ];

  virtualisation.docker.enable = true;

  users = {
    mutableUsers = false;
    users.alex = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      # shell = pkgs.fish;
      hashedPassword =
        "$6$VCoEIErVjk.8YIeB$.xxUkrQgIK68aIWEWIqPulsD1T6a7QjepQqWRqWAZTtY20qxYH2gzl95KmCyzpeu3YeFf7sT3uu91oYoGswTX1";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINF5KDy1T6Z+RlDb+Io3g1uSZ46rhBxhNE39YlG3GPFM averyanalex@gmail.com"
      ];
    };
  };

  services.openssh.enable = true;
  networking.firewall.enable = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Moscow";

  hardware.enableRedistributableFirmware = true;
}
