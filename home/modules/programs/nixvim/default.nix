{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  package =
    if config.hopplaos.desktop.darkTheme
    then self'.packages.nixvim-dark
    else self'.packages.nixvim-light;
in {
  options.hopplaos.programs.nixvim.enable = lib.mkEnableOption "NixVim";

  config = {
    #hopplaos.desktop.editorCommand = "${config.programs.alacritty.package}/bin/alacritty -e tmuxp load -S /run/user/$UID/tmux-$UID/default -y ~/.config/tmux/sessions/nvim.yaml";
    hopplaos.desktop.editorCommand = "${config.programs.alacritty.package}/bin/alacritty -e tmuxp load -S $XDG_RUNTIME_DIR/tmux-$UID/default -y ~/.config/tmux/sessions/nvim.yaml";

    home = {
      packages = [package];
      sessionVariables.EDITOR = "nvim";
    };
  };
}
