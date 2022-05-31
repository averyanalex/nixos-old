{ config, pkgs, ... }:

{
  imports = [ ./hardware/ferret.nix ./common.nix ./lang/ru.nix ./gnome.nix ];

  networking = {
    hostName = "ferret";
    useDHCP = false;
    networkmanager.enable = true;
  };

  users.users.alexey = {
    isNormalUser = true;
    description = "Alexey Averyanov";
    extraGroups = [ "wheel" ];
    uid = 1001;
    hashedPassword =
      "$6$VCoEIErVjk.8YIeB$.xxUkrQgIK68aIWEWIqPulsD1T6a7QjepQqWRqWAZTtY20qxYH2gzl95KmCyzpeu3YeFf7sT3uu91oYoGswTX1";
  };
}
