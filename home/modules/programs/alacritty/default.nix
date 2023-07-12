{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.hopplaos.programs.alacritty;
in {
  options = {
    hopplaos.programs.alacritty = {
      enable =
        mkEnableOption "Alacritty"
        // {
          default = config.hopplaos.desktop.enable;
        };
    };
  };

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) {
    hopplaos.desktop.terminalCommand = "${config.programs.alacritty.package}/bin/alacritty";

    programs.alacritty = {
      enable = true;

      settings = {
        env = {
          WINIT_X11_SCALE_FACTOR = "1";
        };

        window.padding = {
          x = 10;
          y = 10;
        };

        scrolling.history = 50000;

        font = let
          family = "JetBrainsMono Nerd Font";
        in {
          size = 10;
          normal = {
            family = family;
            style = "Regular";
          };
          bold = {
            family = family;
            style = "Bold";
          };
          italic = {
            family = family;
            style = "Italic";
          };
          bold_italic = {
            family = family;
            style = "Bold Italic";
          };
        };

        colors = {
          primary = {
            background = "0x282a36";
            foreground = "0xf8f8f2";
          };
          cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          vi_mode_cursor = {
            text = "CellBackground";
            cursor = "CellForeground";
          };
          search = {
            matches = {
              foreground = "0x44475a";
              background = "0x50fa7b";
            };
            focused_match = {
              foreground = "0x44475a";
              background = "0xffb86c";
            };
          };
          footer_bar = {
            background = "0x282a36";
            foreground = "0xf8f8f2";
          };
          line_indicator = {
            foreground = "None";
            background = "None";
          };
          selection = {
            text = "CellForeground";
            background = "0x44475a";
          };
          normal = {
            black = "0x000000";
            red = "0xff5555";
            green = "0x50fa7b";
            yellow = "0xf1fa8c";
            blue = "0xbd93f9";
            magenta = "0xff79c6";
            cyan = "0x8be9fd";
            white = "0xbfbfbf";
          };
          bright = {
            black = "0x4d4d4d";
            red = "0xff6e67";
            green = "0x5af78e";
            yellow = "0xf4f99d";
            blue = "0xcaa9fa";
            magenta = "0xff92d0";
            cyan = "0x9aedfe";
            white = "0xe6e6e6";
          };
          dim = {
            black = "0x14151b";
            red = "0xff2222";
            green = "0x1ef956";
            yellow = "0xebf85b";
            blue = "0x4d5b86";
            magenta = "0xff46b0";
            cyan = "0x59dffc";
            white = "0xe6e6d1";
          };
        };
      };
    };

    home.shellAliases = {
      ssh = "TERM=xterm-256color ssh";
    };
  };
}
