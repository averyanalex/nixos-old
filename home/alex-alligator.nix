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
      menu = "${pkgs.wofi}/bin/wofi -c ~/.config/wofi/config -I";
      modifier = "Mod4"; # Super
    };
    extraConfig = ''
      exec ${pkgs.mako}/bin/mako # desktop notifications

      # STYLING
      gaps inner 5
      gaps outer 5
      default_border pixel 1
      smart_borders on

      for_window [shell="xdg_shell"] title_format "%title (%app_id)"
      for_window [shell="x_wayland"] title_format "%class - %title"

      ## Window decoration
      # class                 border  backgr. text    indicator child_border
      client.focused          #88c0d0 #434c5e #eceff4 #8fbcbb   #88c0d0
      client.focused_inactive #88c0d0 #2e3440 #d8dee9 #4c566a   #4c566a
      client.unfocused        #88c0d0 #2e3440 #d8dee9 #4c566a   #4c566a
      client.urgent           #ebcb8b #ebcb8b #2e3440 #8fbcbb   #ebcb8b
    '';
  };

  xdg.configFile."wofi/config".source = ./configs/wofi/config;
  xdg.configFile."wofi/config.screenshot".source = ./configs/wofi/config.screenshot;
  xdg.configFile."wofi/style.css".source = ./configs/wofi/style.css;
  xdg.configFile."wofi/style.widgets.css".source = ./configs/wofi/style.widgets.css;
}
