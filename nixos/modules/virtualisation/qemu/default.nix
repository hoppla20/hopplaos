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

  cfg = config.hopplaos.virtualisation.qemu;
in {
  options.hopplaos.virtualisation.qemu = {
    enable = mkEnableOption "Qemu";
  };

  config = let
    unpriv_ping_gid = 10000;
  in
    mkIf cfg.enable {
      users.groups.unpriv_ping = {
        gid = unpriv_ping_gid;
      };
      boot.kernel.sysctl."net.ipv4.ping_group_range" = "${toString unpriv_ping_gid} ${toString unpriv_ping_gid}";
    };
}
