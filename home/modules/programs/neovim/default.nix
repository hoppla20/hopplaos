{ pkgs, config, lib, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.programs.neovim;
in
{
  options.hopplaos.programs.neovim = { enable = mkEnableOption "Neovim"; };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      options = {
        number = true;
        relativenumber = true;
        shiftwidth = 2; # tab width
      };
      globals = { mapleader = ","; };
      extraConfigLua = ''
        if vim.g.vscode then
        else
        end
      '';

      # see https://github.com/nix-community/nixvim#key-mappingndes
      maps = { };
    };
  };
}
