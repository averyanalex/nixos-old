{ lib, config, pkgs, ... }:

{
  config = lib.mkIf config.virtualisation.docker.enable {
    # auto cleanup
    virtualisation.docker.autoPrune.enable = true;
    virtualisation.docker.autoPrune.dates = "daily";
    virtualisation.docker.autoPrune.flags = [ "--all" ];

    # access docker from normal user
    users.users.alex.extraGroups = [ "docker" ];

    # docker-compose
    environment.systemPackages = [ pkgs.docker-compose_2 ];
    environment.shellAliases = { dc = "docker compose"; };
  };
}
