{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf;

  cfg = config.hopplaos.hardware.zsa;
in {
  options.hopplaos.hardware.zsa = {
    enable = mkEnableOption "ZSA";
  };

  config = mkIf cfg.enable {
    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = [
      pkgs.wally-cli
      pkgs.keymapp
    ];
  };
}
