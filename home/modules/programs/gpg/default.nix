{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.programs.gpg;

  inherit (lib) mkEnableOption mkIf mkMerge;
in {
  options = {
    hopplaos.programs.gpg = {
      enable = mkEnableOption "Programs - gpg";
      gpg-agent.enable = mkEnableOption "Services - gpg-agent";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {programs.gpg.enable = true;}
    (mkIf cfg.gpg-agent.enable {
      programs.gpg.scdaemonSettings.disable-ccid = true;
      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        enableScDaemon = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    })
  ]);
}
