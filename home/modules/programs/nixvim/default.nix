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

  cfg = config.hopplaos.programs.nixvim;

  inherit (config.hopplaos.desktop) darkTheme;
in {
  imports = [
    ./plugins/git.nix
    ./plugins/lines.nix
    ./plugins/lsp.nix
    ./plugins/neo-tree.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
  ];

  options.hopplaos.programs.nixvim = {
    enable = mkEnableOption "Nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      colorschemes.catppuccin = {
        enable = true;
        flavour =
          if darkTheme
          then "macchiato"
          else "latte";
      };

      options = {
        number = true;
        shiftwidth = 2;
        foldenable = false;
      };

      globals = {
        mapleader = ",";
      };

      clipboard.providers.wl-copy.enable = true;
      editorconfig.enable = true;

      plugins = {
        alpha.enable = true;
        comment-nvim.enable = true;
        indent-blankline = {
          enable = true;
          useTreesitter = true;
        };
        nix.enable = true;
        which-key.enable = true;
      };
    };
  };
}

