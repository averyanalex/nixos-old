{ config, pkgs, ... }:

{
  imports = [
    ./hardware/lenovo.nix
    ./mounts/ferret.nix
    ./common.nix
    ./lang/ru.nix
    ./gnome.nix
  ];

  networking = {
    hostName = "ferret";
    networkmanager.enable = true;
  };

  services.xserver.displayManager.autoLogin.user = "alexey";

  users.users.alexey = {
    isNormalUser = true;
    description = "Alexey Averyanov";
    extraGroups = [ ];
    uid = 1001;
    hashedPassword =
      "$6$VCoEIErVjk.8YIeB$.xxUkrQgIK68aIWEWIqPulsD1T6a7QjepQqWRqWAZTtY20qxYH2gzl95KmCyzpeu3YeFf7sT3uu91oYoGswTX1";
  };
}
