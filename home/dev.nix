{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # dev
    rnix-lsp
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscodium;
    mutableExtensionsDir = false;
    extensions = with pkgs.unstable.vscode-extensions; [
      serayuzgur.crates
      jnoortheen.nix-ide
      matklad.rust-analyzer
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "even-better-toml";
        publisher = "tamasfe";
        version = "0.16.5";
        sha256 = "pRUiXsZGhTIQx2Qx9NFQ7OGRros3KdzjUlq13nm4pAc=";
      }
      # {
      #   name = "nix-env-selector";
      #   publisher = "arrterian";
      #   version = "1.0.7";
      #   sha256 = "DnaIXJ27bcpOrIp1hm7DcrlIzGSjo4RTJ9fD72ukKlc=";
      # }
      {
        name = "direnv";
        publisher = "mkhl";
        version = "0.6.1";
        sha256 = "5/Tqpn/7byl+z2ATflgKV1+rhdqj+XMEZNbGwDmGwLQ=";
      }
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;

      "files.autoSave" = "afterDelay";
      "diffEditor.ignoreTrimWhitespace" = false;

      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "git.autofetch" = true;

      "terminal.integrated.fontFamily" = "MesloLGS NF";
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
}
