{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf;

  cfg = config.hopplaos.wibu.backup;
in {
  options.hopplaos.wibu.backup = {
    enable = mkEnableOption "Backup";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.lsyncd];

    systemd.services.lsyncd-wibu-workspace-backup = {
      description = "Lsync Wibu Workspace Backup";
      after = ["backup.mount"];
      requires = ["backup.mount"];
      wantedBy = ["multi-user.target"];
      path = [pkgs.rsync];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.lsyncd}/bin/lsyncd -nodaemon --pidfile /run/lsyncd.pid -rsync /home/vincentcui/Workspace/ /backup/Workspace/";
      };
    };
  };
}
