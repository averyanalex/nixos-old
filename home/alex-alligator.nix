{ config, pkgs, ... }:

{
  imports = [ ./alex.nix ];

  home.packages = with pkgs; [
    wl-clipboard
    bemenu
    mako
    alacritty
    gnome3.adwaita-icon-theme

    brave
  ];

  programs.bash.enable = true;
  programs.bash.profileExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      exec sway
    fi
  '';

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    config = {
      # input = {
      #   "1:1:AT_Translated_Set_2_keyboard" = {
      #     xkb_layout = "us,ru";
      #     xkb_options = "grp:alt_shift_toggle";
      #   };
      # };
      output = {
        "DP-1" = { mode = "3440x1440@144Hz"; };
      };
      terminal = "alacritty";
      menu = "${pkgs.sirula}/bin/sirula";
      modifier = "Mod4"; # Super
    };
  };

  xdg.configFile."sirula/config.toml".source = ./configs/sirula/config.toml;
  xdg.configFile."sirula/style.css".source = ./configs/sirula/style.css;
}
