{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;
in {
  options = {
    hopplaos.programs.keepassxc = {
      enable = mkEnableOption "KeePassXC";
    };
  };

  config = {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        keepassxc
        ;
    };
  };
}
