{
  pkgs-unstable,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge concatStringsSep;

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
        name = "JetBrainsMono Nerd Font Mono";
        size = 12;
      };
      extraConfig = let
        features = "+ss02 +ss19 +cv14";
      in ''
        font_features JetBrainsMonoNFM-Regular ${features}
        font_features JetBrainsMonoNFM-Italic ${features}

        font_features JetBrainsMonoNFM-Thin ${features}
        font_features JetBrainsMonoNFM-ThinItalic ${features}

        font_features JetBrainsMonoNFM-Light ${features}
        font_features JetBrainsMonoNFM-LightItalic ${features}
        font_features JetBrainsMonoNFM-ExtraLight ${features}
        font_features JetBrainsMonoNFM-ExtraLightItalic ${features}

        font_features JetBrainsMonoNFM-Medium ${features}
        font_features JetBrainsMonoNFM-MediumItalic ${features}

        font_features JetBrainsMonoNFM-Bold ${features}
        font_features JetBrainsMonoNFM-BoldItalic ${features}
        font_features JetBrainsMonoNFM-ExtraBold ${features}
        font_features JetBrainsMonoNFM-ExtraBoldItalic ${features}

        font_features JetBrainsMonoNFM-SemiBold ${features}
        font_features JetBrainsMonoNFM-SemiBoldItalic ${features}
      '';
      settings = {
        text_composition_strategy = "2.7 0";

        allow_remote_control = true;
        listen_on = "unix:/tmp/kitty";

        window_padding_width = 5;
        disable_ligatures = "cursor";

        tab_bar_min_tabs = 1;
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{index}: {tab.active_wd}{' [{}]'.format(num_windows) if num_windows > 1 else ''}";

        enabled_layouts = let
          default_bias = 70;
          layouts = [
            "fat:mirrored=false;bias=${toString default_bias}"
            "fat:mirrored=true;bias=${toString default_bias}"
            "tall:mirrored=false;bias=${toString default_bias}"
            "tall:mirrored=true;bias=${toString default_bias}"
            "splits:split_axis=vertical"
            "splits:split_axis=horizontal"
            "stack"
          ];
        in
          concatStringsSep "," layouts;
      };
      keybindings = {
        "alt+j" = "kitten pass_keys.py bottom alt+j";
        "alt+k" = "kitten pass_keys.py top alt+k";
        "alt+h" = "kitten pass_keys.py left alt+h";
        "alt+l" = "kitten pass_keys.py right alt+l";
        "alt+n" = "kitten pass_keys.py bottom alt+n";
        "alt+e" = "kitten pass_keys.py top alt+e";
        "alt+p" = "kitten pass_keys.py left alt+p";
        "alt+a" = "kitten pass_keys.py right alt+a";
        "ctrl+shift+enter" = "new_window_with_cwd";
        "ctrl+shift+q" = "close_window";
        "ctrl+shift+w" = "close_tab";
        "ctrl+shift+f2" = "detach_window ask";
        "ctrl+shift+f3" = "detach_tab ask";
        "ctrl+shift+f" = "toggle_layout stack";
        "ctrl+alt+." = "layout_action bias 62 70 85";
        "ctrl+alt+v" = "launch --location=vsplit --cwd=current";
        "ctrl+alt+s" = "launch --location=hsplit --cwd=current";
        "ctrl+alt+j" = "move_window down";
        "ctrl+alt+k" = "move_window up";
        "ctrl+alt+h" = "move_window left";
        "ctrl+alt+l" = "move_window right";
        "ctrl+alt+n" = "move_window down";
        "ctrl+alt+e" = "move_window up";
        "ctrl+alt+p" = "move_window left";
        "ctrl+alt+a" = "move_window right";
        "ctrl+alt+r" = "layout_action rotate";
        "ctrl+backspace" = "send_text all \\x17"; # ctrl+w
      };
      shellIntegration.mode = "enabled";
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
