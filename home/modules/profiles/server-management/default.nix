{
  pkgs-unstable,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.profiles.server-management;
in {
  options.hopplaos.profiles.server-management = {
    enable = lib.mkEnableOption "Server Management";
  };

  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs-unstable)
        kubectl
        kubernetes-helm
        kubeswitch
        openlens
        ;
    };
  };
}
