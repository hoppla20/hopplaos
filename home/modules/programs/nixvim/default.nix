{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  cfg = config.hopplaos.programs.nixvim;
  package =
    if config.hopplaos.desktop.darkTheme
    then self'.packages.nixvim-dark
    else self'.packages.nixvim-light;
in {
  options.hopplaos.programs.nixvim.enable = lib.mkEnableOption "NixVim";

  config = lib.mkIf cfg.enable {
    hopplaos.desktop.editorCommand = "TMUX_TMPDIR=\"${config.home.sessionVariables.TMUX_TMPDIR}\" ${config.programs.alacritty.package}/bin/alacritty -e tmuxp load -y ~/.config/tmux/sessions/nvim.yaml";

    home = {
      packages = [package];
      sessionVariables.EDITOR = "nvim";
    };
  };
}
