{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.programs.zsh;

  inherit (lib) mkEnableOption mkIf;
in {
  options.hopplaos.programs.zsh.enable = mkEnableOption "Programs - zsh";

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;

        prezto = {
          enable = true;
          editor = {
            keymap = "vi";
            dotExpansion = true;
          };
          terminal.autoTitle = true;
          utility.safeOps = true;
          pmodules = lib.mkOrder 1000 [
            "environment"
            "terminal"
            "editor"
            "history"
            "directory"
            "spectrum"
            "utility"
            "git"
            "autosuggestions"
            "completion"
            "prompt"
          ];
          extraConfig = ''
            zstyle ':prezto:module:git:alias' skip 'yes'
            zstyle ':prezto:module:git:log:context' format 'oneline'
          '';
        };
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
