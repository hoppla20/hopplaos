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
    ./plugins/completion.nix
    ./plugins/dashboard.nix
    ./plugins/filetree.nix
    ./plugins/git.nix
    ./plugins/lines.nix
    ./plugins/lsp.nix
    ./plugins/session.nix
    ./plugins/telescope.nix
    ./plugins/tmux.nix
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
      wrap = false;
    };

    globals = {
      mapleader = ",";
    };

    editorconfig.enable = true;
    clipboard.providers.wl-copy.enable = true;

    plugins = {
      comment-nvim.enable = true;
      indent-blankline = {
        enable = true;
        useTreesitter = true;
      };
      nix.enable = true;
      notify = {
        enable = true;
        stages = "slide";
        timeout = 3000;
      };
      nvim-autopairs.enable = true;
      which-key.enable = true;
    };
  };
}
