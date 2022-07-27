{ config, pkgs, ... }:

{
  i18n.defaultLocale = "ru_RU.UTF-8";
  console = {
    font = "cyr-syn16";
    keyMap = "us";
  };
}
