{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # sway
    wl-clipboard # clipboard support
    # TODO: change clipboard manager (CopyQ?)
    clipman # clipboard manager
    # rofi-wayland # apps menu
    # TODO: setup dunst
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
    noto-fonts-cjk
    meslo-lgs-nf
    # (nerdfonts.override { fonts = [ "Meslo" ]; })

    xfce.thunar # file manager
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    xfce.tumbler # previews
  ];

  programs.bash.enable = true;
  programs.bash.profileExtra = ''
    if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      sway
    fi
  '';

  fonts.fontconfig.enable = true;

  wayland.windowManager.sway = {
    # TODO: random wallpaper from ~/Pictures/Wallpapers/3440x1440
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
          "${cfg.modifier}+q" = "kill";

          # TODO: clipboard history
          # "${cfg.modifier}+h" = "exec clipman pick -t rofi";
          # TODO: run in terminal
          # "${cfg.modifier}+Shift+d" = "exec rofi -show run -run-shell-command \'{terminal} -e zsh -ic \"{cmd} && read\"\'";

          "Mod4+m" = "exec rofi -show emoji";

          "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
          "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";

          "XF86MonBrightnessDown" = "exec light -U 10";
          "XF86MonBrightnessUp" = "exec light -A 10";

          "Print" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -d)" - | tee ~/Pictures/Screenshots/$(date +%H_%M_%S-%d_%m_%Y).png | wl-copy -t image/png'';
          "Shift+Print" = ''exec ${pkgs.grim}/bin/grim - | tee ~/Pictures/Screenshots/$(date +%H_%M_%S-%d_%m_%Y).png | wl-copy -t image/png'';
          # TODO: screenshot focused window
          # "Mod1+Print" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.sway}/bin/swaymsg -t get_tree | ${pkgs.jq}/bin/jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" - | tee ~/Pictures/Screenshots/$(date +%H_%M_%S-%d_%m_%Y).png | wl-copy -t image/png'';
          # TODO: setup flameshot
        };
      terminal = "alacritty";
      menu = "rofi -show drun";
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
      # exec telegram-desktop -startintray
      # exec element-desktop --hidden
    '';
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "MesloLGS NF";
    };
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    plugins = [ pkgs.rofi-emoji ];
    terminal = "alacritty";
    extraConfig = {
      modi = "drun,run,emoji,ssh";
      show-icons = true;
    };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };

  services.gpg-agent.pinentryFlavor = "qt"; # TODO: fix gnome3 pinentry

  services.gnome-keyring.enable = true;
}
