{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;

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

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) (mkMerge [
    {
      hopplaos.desktop.terminalCommand = "${config.programs.alacritty.package}/bin/alacritty";

      xdg.configFile."alacritty/colorscheme.yaml".text = builtins.readFile (config.scheme {
        templateRepo = inputs.base16-alacritty;
        target = "default-256";
      });

      programs.alacritty = {
        enable = true;

        settings = {
          import = [
            "~/.config/alacritty/colorscheme.yaml"
          ];

          env = {WINIT_X11_SCALE_FACTOR = "1";};

          window.padding = {
            x = 10;
            y = 10;
          };

          scrolling.history = 50000;

          key_bindings = [
            {
              mods = "Command";
              key = "Back";
              chars = "\\x1b\\x7f";
            }
          ];

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
        };
      };
    }
    (mkIf config.hopplaos.programs.ssh.enable {
      hopplaos.programs.ssh.matchBlocks = {
        "*" = {setEnv = {TERM = "xterm-256color";};};
      };
    })
  ]);
}
