{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;

  cfg = config.hopplaos.desktop.cosmic;
in {
  options = {
    hopplaos.desktop.cosmic.enable = mkEnableOption "Cosmic DE";
  };

  config = mkIf cfg.enable {
    services = {
      desktopManager.cosmic.enable = true;
      displayManager.cosmic-greeter.enable = true;
    };
  };
}
