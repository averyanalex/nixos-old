{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # sway
    wl-clipboard # clipboard support
    clipman # clipboard manager
    wofi # apps menu
    mako # notifications
    gnome3.adwaita-icon-theme # icons
    pulseaudio # volume control

    # keyring
    gnome.seahorse
    gnome.gnome-keyring
    gcr

    # fonts
    dejavu_fonts
    freefont_ttf
    gyre-fonts # TrueType substitutes for standard PostScript fonts
    liberation_ttf
    unifont
    noto-fonts-emoji
    meslo-lgs-nf
    # (nerdfonts.override { fonts = [ "Meslo" ]; })
  ];

  programs.bash.enable = true;
  programs.bash.profileExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      sway
    fi
  '';

  fonts.fontconfig.enable = true;

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export NIXOS_OZONE_WL=1

      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_QPA_PLATFORM=wayland
    '';
    config = {
      input = {
        "*" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:alt_shift_toggle";
        };
      };
      bars = [ ];
      keybindings =
        let
          cfg = config.wayland.windowManager.sway.config;
        in
        lib.mkOptionDefault {
          "${cfg.modifier}+h" = "exec clipman pick -t wofi";
          "${cfg.modifier}+q" = "kill";
          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";
        };
      terminal = "alacritty";
      menu = "wofi -c ~/.config/wofi/config -I";
      modifier = "Mod4"; # Super
    };
    extraConfig = ''
      # polkit
      exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

      # vnc
      # exec ${pkgs.unstable.wayvnc}/bin/wayvnc --gpu

      # clipboard
      exec clipman restore
      exec wl-paste -t text --watch clipman store

      # STYLING
      gaps inner 5
      gaps outer 5
      default_border pixel 1
      smart_borders on

      for_window [shell="xdg_shell"] title_format "%title (%app_id)"
      for_window [shell="x_wayland"] title_format "%class - %title"

      # AUTOSTART
      exec telegram-desktop -startintray
      exec element-desktop --hidden
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "MesloLGS NF";
    };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };

  services.gpg-agent.pinentryFlavor = "gnome3";

  services.gnome-keyring.enable = true;

  xdg.configFile."wofi/config".source = ./configs/wofi/config;
  xdg.configFile."wofi/config.screenshot".source = ./configs/wofi/config.screenshot;
  xdg.configFile."wofi/style.css".source = ./configs/wofi/style.css;
  xdg.configFile."wofi/style.widgets.css".source = ./configs/wofi/style.widgets.css;
}
