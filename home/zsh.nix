{ config, pkgs, lib, ... }:

{
  programs.bash.enable = true;
  programs.bash.initExtra = ''
    if [[ "$(tty)" != /dev/tty* && $(ps --no-header --pid=$PPID --format=comm) != "zsh" && -z $BASH_EXECUTION_STRING ]]; then
      exec zsh
    fi
  '';

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      # theme = "powerlevel10k";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./configs/p10k-config;
        file = "p10k.zsh";
      }
    ];
  };
}
