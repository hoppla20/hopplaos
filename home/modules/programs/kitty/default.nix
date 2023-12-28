{
  pkgs-unstable,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.programs.kitty;
in {
  options = {
    hopplaos.programs.kitty = {
      enable = mkEnableOption "Kitty";
    };
  };

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) {
    hopplaos.desktop.terminalCommand = "${config.programs.kitty.package}/bin/kitty";

    programs.kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 10;
      };
      settings = {
        allow_remote_control = true;
        listen_on = "unix:@mykitty";

        window_padding_width = 5;
        disable_ligatures = "always";

        tab_bar_style = "powerline";
        tab_powerline_style = "round";

        enabled_layouts = "splits:split_axis=vertical,fat:bias=62,tall:bias=62,stack";
      };
      keybindings = {
        "alt+j" = "kitten pass_keys.py bottom alt+j";
        "alt+k" = "kitten pass_keys.py top alt+k";
        "alt+h" = "kitten pass_keys.py left alt+h";
        "alt+l" = "kitten pass_keys.py right alt+l";
        "ctrl+shift+enter" = "new_window_with_cwd";
        "ctrl+shift+f" = "toggle_layout stack";
        "ctrl+." = "layout_action bias 50 62 70";
        "ctrl+," = "layout_action bias 62";
        "ctrl+alt+v" = "launch --location=vsplit --cwd=current";
        "ctrl+alt+s" = "launch --location=hsplit --cwd=current";
        "ctrl+alt+j" = "move_window down";
        "ctrl+alt+k" = "move_window up";
        "ctrl+alt+h" = "move_window left";
        "ctrl+alt+l" = "move_window right";
        "ctrl+shift+alt+j" = "layout_action move_to_screen_edge bottom";
        "ctrl+shift+alt+k" = "layout_action move_to_screen_edge top";
        "ctrl+shift+alt+h" = "layout_action move_to_screen_edge left";
        "ctrl+shift+alt+l" = "layout_action move_to_screen_edge right";
        "ctrl+alt+r" = "layout_action rotate";
      };
      shellIntegration.enableZshIntegration = config.programs.zsh.enable;
      theme = "Catppuccin-${
        if config.hopplaos.desktop.darkTheme
        then "Macchiato"
        else "Latte"
      }";
    };

    xdg.configFile = {
      "kitty/pass_keys.py".source = "${inputs.vim-kitty-navigator.outPath}/pass_keys.py";
      "kitty/get_layout.py".source = "${inputs.vim-kitty-navigator.outPath}/get_layout.py";
    };
  };
}
