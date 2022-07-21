{ config, pkgs, lib, ... }:

{
  imports = [ ./alex.nix ];

  home.sessionVariables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };

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
    gcr

    # apps
    libreoffice-fresh
    unstable.brave
    unstable.tdesktop
    element-desktop

    # dev
    rnix-lsp

    # compilers
    rust-bin.stable.latest.default
    gcc

    # tools
    binutils
    pkg-config

    # libs
    openssl
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
      serayuzgur.crates
      #tamasfe.even-better-toml
      #arrterian.nix-env-selector
      jnoortheen.nix-ide
      matklad.rust-analyzer
      #ms-python.python
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      # {
      #   name = "rust-analyzer";
      #   publisher = "rust-lang";
      #   version = "0.4.1133";
      #   sha256 = "np7LfRHJqcctzSHLZQtVn3aUlzYZ3gfnsRX2w/iYASI=";
      # }
      {
        name = "even-better-toml";
        publisher = "tamasfe";
        version = "0.16.5";
        sha256 = "pRUiXsZGhTIQx2Qx9NFQ7OGRros3KdzjUlq13nm4pAc=";
      }
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "files.autoSave" = "afterDelay";
      "diffEditor.ignoreTrimWhitespace" = false;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.autofetch" = true;
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
      input = {
        "*" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:alt_shift_toggle";
        };
      };
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
      # polkit
      exec ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1

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
    '';
  };

  services.gnome-keyring.enable = true;

  xdg.configFile."alacritty/alacritty.yml".source = ./configs/alacritty.yml;

  xdg.configFile."wofi/config".source = ./configs/wofi/config;
  xdg.configFile."wofi/config.screenshot".source = ./configs/wofi/config.screenshot;
  xdg.configFile."wofi/style.css".source = ./configs/wofi/style.css;
  xdg.configFile."wofi/style.widgets.css".source = ./configs/wofi/style.widgets.css;
}
