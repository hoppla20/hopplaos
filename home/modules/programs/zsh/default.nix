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

        initExtra = ''
          [[ -f "${./p10k.zsh}" ]] && source "${./p10k.zsh}"
        '';

        prezto = {
          enable = true;

          editor = {
            keymap = "emacs";
            dotExpansion = true;
          };
          terminal.autoTitle = true;
          utility.safeOps = true;
          prompt.theme = "powerlevel10k";

          pmodules = lib.mkOrder 1000 [
            "environment"
            "terminal"
            "editor"
            "history"
            "directory"
            "spectrum"
            "utility"
            "syntax-highlighting"
            "autosuggestions"
            "git"
            "archive"
            "prompt"
          ];

          extraConfig = ''
            zstyle ':prezto:module:git:alias' skip 'yes'
            zstyle ':prezto:module:git:log:context' format 'oneline'
          '';

          extraModules = ["zprof"];
        };
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
