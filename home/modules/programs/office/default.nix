{ pkgs, config, lib, ... }:
let inherit (lib) mkEnableOption mkIf;
in {
  options.hopplaos.programs.office.enable = mkEnableOption "Office suite";

  config = {
    home.packages = builtins.attrValues { inherit (pkgs) libreoffice; };
  };
}
