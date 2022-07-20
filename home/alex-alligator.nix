{ config, pkgs, lib, ... }:

{
  imports = [ ./alex.nix ];

  home.packages = with pkgs; [
    wl-clipboard
    clipman

    wofi

    bemenu
    mako
    alacritty
    gnome3.adwaita-icon-theme

    gnome.seahorse
    gnome.gnome-keyring

    libreoffice-fresh
    unstable.brave
    unstable.tdesktop
  ];

  programs.bash.enable = true;
  programs.bash.profileExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      sway
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
      keybindings =
        let
          cfg = config.wayland.windowManager.sway.config;
        in
        lib.mkOptionDefault {
          "${cfg.modifier}+h" = "exec clipman pick -t wofi";
          "${cfg.modifier}+q" = "kill";
        };
      output = {
        "DP-1" = { mode = "3440x1440@144Hz"; };
      };
      terminal = "alacritty";
      menu = "wofi -c ~/.config/wofi/config -I";
      modifier = "Mod4"; # Super
    };
    extraConfig = ''
      # clipboard
      exec clipman restore
      exec wl-paste -t text --watch clipman store

      exec ${pkgs.mako}/bin/mako # desktop notifications
      # exec gnome-keyring-daemon --daemonize --start --components=gpg,pkcs11,secrets,ssh # secret service

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
    # extraSessionCommands = ''
    #   eval $(gnome-keyring-daemon --start)
    # '';
  };

  services.gnome-keyring.enable = true;

  xdg.configFile."alacritty/alacritty.yml".source = ./configs/alacritty.yml;

  xdg.configFile."wofi/config".source = ./configs/wofi/config;
  xdg.configFile."wofi/config.screenshot".source = ./configs/wofi/config.screenshot;
  xdg.configFile."wofi/style.css".source = ./configs/wofi/style.css;
  xdg.configFile."wofi/style.widgets.css".source = ./configs/wofi/style.widgets.css;
}
