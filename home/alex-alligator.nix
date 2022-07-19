{ config, pkgs, ... }:

{
  imports = [ ./alex.nix ];

  home.packages = with pkgs; [
    wl-clipboard
    bemenu
    mako
    alacritty
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    config = {
      input = {
        # "1:1:AT_Translated_Set_2_keyboard" = {
        #   xkb_layout = "us,ru";
        #   xkb_options = "grp:alt_shift_toggle";
        # };
      };
      terminal = "alacritty";
      menu = "bemenu-run";
      modifier = "Mod4"; # Super
    };
  };
}
