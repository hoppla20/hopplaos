{
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

  cfg = config.hopplaos.programs.git;
in {
  options.hopplaos.programs.git = {
    enable = mkEnableOption "Git";

    userName = mkOption {
      type = types.str;
    };
    userEmail = mkOption {
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      diff-so-fancy.enable = true;

      ignores = [
        "/.direnv/"
      ];

      extraConfig = {
        core.editor = "nvim";
        pull.rebase = "false";
        init.defaultBranch = "main";
      };

      inherit (cfg) userName userEmail;
    };
  };
}
