{ pkgs, config, lib, ... }:
let
  cfg = config.hopplaos.programs.ssh;

  inherit (lib) types mkOption mkEnableOption mkIf;
in
{
  options = {
    hopplaos.programs.ssh = {
      enable = mkEnableOption "Programs - ssh";
      matchBlocks = mkOption {
        type = types.attrs;
        default = { };
      };
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks = cfg.matchBlocks;
    };
  };
}
