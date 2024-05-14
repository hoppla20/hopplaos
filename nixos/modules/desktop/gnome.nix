{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;

  cfg = config.hopplaos.desktop.gnome;
in {
  options = {
    hopplaos.desktop.gnome = {
      enable = mkEnableOption "Gnome DE";
    };
  };

  config = mkIf cfg.enable {
    hardware.pulseaudio.enable = false;
    services = {
      xserver = {
        enable = true;
        displayManager.gdm = {
          enable = true;
          autoSuspend = false;
        };
        desktopManager.gnome.enable = true;
      };
    };

    environment = {
      gnome.excludePackages = builtins.attrValues {
        inherit
          (pkgs)
          gedit
          gnome-tour
          gnome-console
          snapshot # camera
          ;

        inherit
          (pkgs.gnome)
          cheese # camera
          gnome-music
          epiphany # web browser
          geary # email
          gnome-characters
          tali # game
          iagno # game
          hitori # game
          gnome-contacts
          gnome-initial-setup
          gnome-terminal
          ;
      };

      systemPackages = builtins.attrValues {
        inherit
          (pkgs)
          gparted
          ;

        inherit
          (pkgs.gnome)
          gnome-tweaks
          ;
      };
    };
  };
}
