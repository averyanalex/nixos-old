{ lib, config, pkgs, ... }:

{
  options.virtualisation.docker.enableWatchtower = lib.mkOption {
    type = lib.types.bool;
    default = false; # config.virtualisation.docker.enable
    description = ''
      Enable automatic image updates.
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf config.virtualisation.docker.enable {
      # auto cleanup
      virtualisation.docker.autoPrune.enable = true;
      virtualisation.docker.autoPrune.dates = "daily";
      virtualisation.docker.autoPrune.flags = [ "--all" ];

      # access docker from normal user
      users.users.alex.extraGroups = [ "docker" ];

      # docker-compose
      environment.systemPackages = [ pkgs.docker-compose_2 ];
      environment.shellAliases = { dc = "docker compose"; };
    })
    (lib.mkIf config.virtualisation.docker.enableWatchtower {
      virtualisation.oci-containers = {
        backend = "docker";
        containers.watchtower = {
          image = "containrrr/watchtower";
          volumes = [ "/var/run/docker.sock:/var/run/docker.sock" ];
        };
      };
    })
    {
      assertions = [{
        assertion = !(config.virtualisation.docker.enableWatchtower
          && !config.virtualisation.docker.enable);
        message = "Docker needed to use watchtower";
      }];
    }
  ];
}
