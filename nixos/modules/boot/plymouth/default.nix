{ pkgs, config, lib, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  bootCfg = config.hopplaos.boot;
  cfg = bootCfg.plymouth;
in {
  options.hopplaos.boot.plymouth = {
    enable = mkEnableOption "Plymouth boot splashscreen";
  };

  config = mkIf (bootCfg.enable && cfg.enable) {
    boot.plymouth = {
      enable = true;
      themePackages = [ pkgs.adi1090x-plymouth-themes ];
      theme = "connect";
    };
  };
}
