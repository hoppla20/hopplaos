{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.hardware;

  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    ;

  monitorModule = types.submodule {
    options = {
      resolution = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "1920x1080";
      };
      refreshRate = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 60;
      };
      position = mkOption {
        default = null;
        type = types.nullOr (types.submodule {
          options = {
            x = mkOption {
              type = types.int;
              default = 0;
            };
            y = mkOption {
              type = types.int;
              default = 0;
            };
          };
        });
      };
      scale = mkOption {
        type = types.int;
        default = 1;
      };
      transform = mkOption {
        type = types.nullOr (types.enum [
          "90"
          "180"
          "270"
          "flipped"
          "flipped-90"
          "flipped-180"
          "flipped-270"
        ]);
        default = null;
        example = "90";
      };
      background = mkOption {
        type = types.nullOr (types.submodule {
          options = {
            file = mkOption {
              type = types.str;
              example = "~/.config/wallpapers/wallpaper.jpg";
            };
            mode = mkOption {
              type = types.str;
              example = "fill";
            };
          };
        });
        default = {
          file = config.hopplaos.desktop.defaultWallpaper;
          mode = "fill";
        };
      };
    };
  };
in {
  options = {
    hopplaos.hardware = {
      bluetooth.enable = mkEnableOption "Bluetooth" // {default = true;};
      monitors = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              default = null;
            };
            value = mkOption {
              type = monitorModule;
              default = {};
            };
          };
        });
        default = [];
      };
    };
  };
}
