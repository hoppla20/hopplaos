{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.programs.minecraft;
in {
  options.hopplaos.programs.minecraft = {
    enable = lib.mkEnableOption "Minecraft";
    jrePackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.temurin-jre-bin;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.prismlauncher
      cfg.jrePackage
    ];
  };
}
