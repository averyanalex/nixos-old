{ config, pkgs, ... }:

{
  imports =
    [ ./hardware/qemu.nix ./mounts/runner.nix ./common.nix ./lang/en.nix ];

  services.openssh.ports = [ 22103 ];

  virtualisation.docker.enable = true;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "daily";

  age.secrets.gitsrv-runner-token.file = ./secrets/gitsrv-runner-token.age;

  services.gitlab-runner = {
    enable = true;
    gracefulTermination = true;
    services = {
      averyanalex-whale-docker = {
        registrationConfigFile = config.age.secrets.gitsrv-runner-token.path;
        tagList = [ "averyanalex" "docker" ];
        runUntagged = true;
        limit = 4;
        executor = "docker";
        dockerImage = "debian:11";
      };
    };
  };

  networking = {
    hostName = "runner";

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
