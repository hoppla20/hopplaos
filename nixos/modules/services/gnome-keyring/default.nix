{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.hopplaos.services.gnome-keyring;
in {
  options.hopplaos.services.gnome-keyring = {
    enable = mkEnableOption "Gnome keyring";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.gdm-launch-environment.text = ''
      auth optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
      session optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
    '';
  };
}
