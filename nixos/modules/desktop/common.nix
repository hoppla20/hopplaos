{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;

  cfg = config.hopplaos.desktop;
in {
  options = {
    hopplaos.desktop.enable = mkEnableOption "Cosmic DE";
  };

  config = mkIf cfg.enable {
    services = {
      xserver.excludePackages = [pkgs.xterm];

      printing = {
        enable = true;
        drivers = [pkgs.gutenprint pkgs.canon-cups-ufr2 pkgs.hplipWithPlugin];
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
    };

    security.rtkit.enable = true;

    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        wl-clipboard
        ;
    };
  };
}
