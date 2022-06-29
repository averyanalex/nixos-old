{ lib, config, pkgs, ... }:

{
  config = lib.mkIf config.virtualisation.docker.enable {
    # auto cleanup
    virtualisation.docker.autoPrune.enable = lib.mkDefault true;
    virtualisation.docker.autoPrune.dates = lib.mkDefault "daily";
    virtualisation.docker.autoPrune.flags = lib.mkDefault [ "--all" ];

    # access docker from normal user
    users.users.alex.extraGroups = [ "docker" ];

    # docker-compose
    environment.systemPackages = lib.mkDefault [ pkgs.docker-compose_2 ];
    environment.shellAliases = lib.mkDefault { dc = "docker compose"; };
  };
}
