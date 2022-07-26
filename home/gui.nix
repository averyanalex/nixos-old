{ config, pkgs, lib, ... }:

{
  imports = [ ./sway.nix ./apps.nix ./dev.nix ];
}
