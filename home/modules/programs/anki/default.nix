{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.programs.anki;
in {
  options.hopplaos.programs.anki = {
    enable = mkEnableOption "Anki";
  };

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) {
    home.packages = [
      pkgs.anki
      pkgs.markdown-anki-decks
      pkgs.markdown2anki
    ];
  };
}
