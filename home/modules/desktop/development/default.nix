{
  pkgs,
  config,
  lib,
  ...
}: let
  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.development;
in {
  options = {
    hopplaos.desktop.development = {
      enable = lib.mkEnableOption "Development" // {default = desktopCfg.enable;};
    };
  };

  config = lib.mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        powershell
        insomnia
        yaml-language-server
        pyright
        shellcheck
        ;
    };
  };
}
