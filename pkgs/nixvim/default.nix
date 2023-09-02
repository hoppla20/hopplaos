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
in {
  imports = [
    ./plugins/git.nix
    ./plugins/lines.nix
    ./plugins/lsp.nix
    ./plugins/neo-tree.nix
    ./plugins/telescope.nix
    ./plugins/treesitter.nix
  ];

  options = {
    colorschemes.darkTheme = mkEnableOption "Dark Theme" // {default = false;};
  };

  config = {
    colorschemes.catppuccin = {
      enable = true;
      flavour =
        if config.colorschemes.darkTheme
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

    editorconfig.enable = true;
    clipboard.providers.wl-copy.enable = true;

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
}
