{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.networking;

  inherit (lib) types mkIf mkOption mkEnableOption;
in {
  options = {
    hopplaos.networking = {
      enable = mkEnableOption "HopplaOS Networking" // {default = true;};

      timeServers = mkOption {
        type = types.listOf types.str;
        default = [
          "0.de.pool.ntp.org"
          "1.de.pool.ntp.org"
          "2.de.pool.ntp.org"
          "3.de.pool.ntp.org"
        ];
      };

      hostId = mkOption {
        type = types.str;
        default =
          builtins.substring 0 8
          (builtins.hashString "md5" config.networking.hostName);
      };

      firewall = {
        enable = mkEnableOption "HopplaOS Networking - Firewall";

        allowedTCPPorts = mkOption {
          type = types.listOf types.int;
          default = [];
        };
      };

      wakeOnLan = {
        enable = mkEnableOption "HopplaOS Networking - WakeOnLan";
        interface = mkOption {
          type = types.str;
          example = "enp4s0";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    # allow temporary changes to /etc/hosts
    environment.etc.hosts.mode = "0644";

    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
      };
      inherit (cfg) hostId;
      inherit (cfg) timeServers;
      firewall = {
        inherit (cfg.firewall) enable;
        checkReversePath = true;
        inherit (cfg.firewall) allowedTCPPorts;
      };
    };

    services.resolved = {
      enable = true;
      fallbackDns = ["1.1.1.1" "1.0.0.1"];
    };

    systemd.services.wakeonlan = mkIf cfg.wakeOnLan.enable {
      description = "WakeOnLan";
      after = ["network.target"];
      requires = ["network.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.ethtool}/sbin/ethtool -s ${cfg.wakeOnLan.interface} wol g";
      };
    };
  };
}
