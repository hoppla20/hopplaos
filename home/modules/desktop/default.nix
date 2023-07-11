{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.desktop;

  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    ;
in {
  imports = [
    ./music
    ./wayland/hyprland
    ./wayland/sway
    ./wayland/common.nix
  ];

  options = {
    hopplaos.desktop = {
      enable = mkEnableOption "HopplaOS Desktop";

      terminalCommand = mkOption {
        type = types.str;
        readOnly = true;
      };
      browserCommand = mkOption {
        type = types.str;
        readOnly = true;
      };
      editorCommand = mkOption {
        type = types.str;
        readOnly = true;
        default = "true";
      };
      fileManagerCommand = mkOption {
        type = types.str;
        readOnly = true;
        default = "thunar";
      };
    };
  };

  config = {
    hopplaos.desktop.browserCommand = "${pkgs.brave}/bin/brave --use-angle=vulkan --use-cmd-decoder=passthrough";

    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        brave
        ;
    };

    xdg.configFile = {
      "wallpapers/wallpaper.jpg".source = ./wallpaper.jpg;
    };
  };
}
