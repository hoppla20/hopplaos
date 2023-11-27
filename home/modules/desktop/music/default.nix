{
  pkgs,
  config,
  lib,
  inputs',
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf;

  audioLimit = 150;
  audioStep = 5;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.audio;
in {
  options = {
    hopplaos.desktop = {
      audio = {
        enable =
          mkEnableOption "HopplaOS Audio"
          // {
            default = desktopCfg.enable;
          };

        controlCommands = {
          raise = mkOption {
            type = types.str;
            readOnly = true;
            default = "wpctl set-volume -l ${
              toString audioLimit
            } @DEFAULT_AUDIO_SINK@ ${toString audioStep}%+";
          };
          lower = mkOption {
            type = types.str;
            readOnly = true;
            default = "wpctl set-volume -l ${
              toString audioLimit
            } @DEFAULT_AUDIO_SINK@ ${toString audioStep}%-";
          };
          mute = mkOption {
            type = types.str;
            readOnly = true;
            default = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
        };

        managerCommand = mkOption {
          type = types.str;
          readOnly = true;
          default = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        playerCommand = mkOption {
          type = types.str;
          readOnly = true;
          default = "${config.programs.spicetify.spicedSpotify}/bin/spotify";
        };
      };
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    home.packages =
      builtins.attrValues {inherit (pkgs) pavucontrol playerctl;};

    programs.spicetify = let
      spicePkgs = inputs'.spicetify-nix.packages.default;
    in {
      enable = true;
      theme = spicePkgs.themes.catppuccin;
      colorScheme =
        if config.hopplaos.desktop.darkTheme
        then "macchiato"
        else "latte";
      enabledExtensions = builtins.attrValues {
        inherit
          (spicePkgs.extensions)
          keyboardShortcut
          groupSession
          ;
      };
    };
  };
}
