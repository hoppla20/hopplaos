{ pkgs, config, lib, ... }:
let
  cfg = config.hopplaos.networking;

  inherit (lib) types mkIf mkOption mkEnableOption;
in
{
  options = {
    hopplaos.networking = {
      enable = mkEnableOption "HopplaOS Networking" // { default = true; };

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
        default = builtins.substring 0 8
          (builtins.hashString "md5" config.networking.hostName);
      };

      firewall = {
        enable = mkEnableOption "HopplaOS Networking - Firewall";

        allowedTCPPorts = mkOption {
          type = types.listOf types.int;
          default = [ ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      hostId = cfg.hostId;
      timeServers = cfg.timeServers;
      firewall = mkIf cfg.firewall.enable {
        enable = true;
        checkReversePath = true;
        allowedTCPPorts = cfg.firewall.allowedTCPPorts;
      };
    };
  };
}
