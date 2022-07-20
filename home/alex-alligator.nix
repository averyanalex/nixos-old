{ config, pkgs, lib, ... }:

{
  imports = [ ./alex.nix ];

  home.packages = with pkgs; [
    # sway
    wl-clipboard
    clipman
    wofi
    bemenu
    mako
    gnome3.adwaita-icon-theme
    alacritty

    gnome.seahorse
    gnome.gnome-keyring

    # apps
    libreoffice-fresh
    unstable.brave
    unstable.tdesktop

    # dev
    rnix-lsp
  ];
  
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;
    mutableExtensionsDir = false;
    extensions = with pkgs.unstable.vscode-extensions; [
      #ms-toolsai.jupyter
      #usernamehw.errorlens
      #asvetliakov.vscode-neovim
      #vadimcn.vscode-lldb
      #serayuzgur.crates
      #tamasfe.even-better-toml
      #arrterian.nix-env-selector
      jnoortheen.nix-ide
      #ms-python.python
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "files.autoSave" = "afterDelay";
      "diffEditor.ignoreTrimWhitespace" = false;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
    };
  };

  programs.git = {
    enable = true;
    userName = "averyanalex";
    userEmail = "alex@averyan.ru";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

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
      export NIXOS_OZONE_WL=1

      export _JAVA_AWT_WM_NONREPARENTING=1
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export QT_QPA_PLATFORM=wayland
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

      # desktop notifications
      exec ${pkgs.mako}/bin/mako
      
      # secret service
      # exec gnome-keyring-daemon --daemonize --start --components=gpg,pkcs11,secrets,ssh

      # STYLING
      gaps inner 5
      gaps outer 5
      default_border pixel 1
      smart_borders on

      for_window [shell="xdg_shell"] title_format "%title (%app_id)"
      for_window [shell="x_wayland"] title_format "%class - %title"

      ## window decoration
      # class                 border  backgr. text    indicator child_border
      client.focused          #88c0d0 #434c5e #eceff4 #8fbcbb   #88c0d0
      client.focused_inactive #88c0d0 #2e3440 #d8dee9 #4c566a   #4c566a
      client.unfocused        #88c0d0 #2e3440 #d8dee9 #4c566a   #4c566a
      client.urgent           #ebcb8b #ebcb8b #2e3440 #8fbcbb   #ebcb8b

      # AUTOSTART
      exec telegram-desktop -startintray
    '';
  };

  services.gnome-keyring.enable = true;

  xdg.configFile."alacritty/alacritty.yml".source = ./configs/alacritty.yml;

  xdg.configFile."wofi/config".source = ./configs/wofi/config;
  xdg.configFile."wofi/config.screenshot".source = ./configs/wofi/config.screenshot;
  xdg.configFile."wofi/style.css".source = ./configs/wofi/style.css;
  xdg.configFile."wofi/style.widgets.css".source = ./configs/wofi/style.widgets.css;
}
