{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.hopplaos.programs.ranger;
in {
  options.hopplaos.programs.ranger = {
    enable = mkEnableOption "ranger file manager";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.ranger];

    xdg.configFile = {
      "ranger/commands.py".source = ./commands.py;
      "ranger/rc.conf".text = ''
        map <A-f> fzf_select
        map <C-g> fzf_locate
      '';
      "ranger/plugins/zoxide" = {
        source = inputs.ranger-zoxide.outPath;
        recursive = true;
      };
    };
  };
}
