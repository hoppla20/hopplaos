{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.programs.zsh;

  inherit (lib) mkEnableOption mkIf;
in {
  options = {hopplaos.programs.zsh.enable = mkEnableOption "Programs - zsh";};

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        defaultKeymap = "emacs";
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
