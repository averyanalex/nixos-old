{ lib, config, pkgs, ... }:

{
  options.virtualisation.docker.enableWatchtower = lib.mkOption {
    type = lib.types.bool;
    default = false; # config.virtualisation.docker.enable
    description = ''
      Enable automatic image updates.
    '';
  };

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

    # watchtower
    virtualisation.oci-containers.containers =
      lib.Mkif config.virtualisation.docker.enableWatchtower {
        watchtower = {
          image = "containrrr/watchtower";
          volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
        };
      };
  };
}
