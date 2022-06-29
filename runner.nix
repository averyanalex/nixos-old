{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/runner.nix ./common.nix ./lang/en.nix ];

  virtualisation.docker.enable = true;

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    buildkit = {
      image = "moby/buildkit:buildx-stable-1";
      extraOptions = [ "--privileged" ];
      volumes =
        [ "/var/lib/buildkit:/var/lib/buildkit" "/run/buildkit:/run/buildkit" ];
    };
  };

  age.secrets.gitsrv-runner-token.file = ./secrets/gitsrv-runner-token.age;

  services.gitlab-runner = {
    enable = true;
    gracefulTermination = true;
    services = {
      averyanalex-whale-docker = {
        description = "averyanalex-whale-docker";
        registrationConfigFile = config.age.secrets.gitsrv-runner-token.path;
        tagList = [ "averyanalex" "docker" ];
        runUntagged = true;
        limit = 4;
        executor = "docker";
        dockerImage = "debian:11";
      };
      averyanalex-whale-buildkit = {
        description = "averyanalex-whale-buildkit";
        registrationConfigFile = config.age.secrets.gitsrv-runner-token.path;
        tagList = [ "averyanalex" "buildkit" ];
        limit = 1;
        executor = "docker";
        dockerImage = "moby/buildkit:buildx-stable-1";
        dockerVolumes = [ "/run/buildkit:/run/buildkit" ];
      };
    };
  };

  networking = {
    hostName = "runner";
    id = 103;

    defaultGateway = {
      address = "192.168.43.1";
      interface = "enp6s18";
    };

    nat.enable = false;
    firewall.enable = false;

    interfaces = {
      enp6s18 = {
        ipv4 = {
          addresses = [{
            address = "192.168.43.2";
            prefixLength = 24;
          }];
        };
      };
    };
  };
}
