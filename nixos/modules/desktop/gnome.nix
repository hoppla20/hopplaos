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
    hopplaos.desktop = {
      enable = mkEnableOption "HopplaOS Desktop";
    };
  };

  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    services = {
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

      xserver = {
        enable = true;
        displayManager.gdm = {
          enable = true;
          autoSuspend = false;
        };
        desktopManager.gnome.enable = true;
        excludePackages = [pkgs.xterm];
      };
    };
    security.rtkit.enable = true;

    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        wl-clipboard
        ;

      inherit
        (pkgs.gnome)
        gnome-tweaks
        ;
    };
  };
}
