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
in {
  options = {
    hopplaos.desktop = {
      music = {
        enable =
          mkEnableOption "HopplaOS Audio"
          // {
            default = desktopCfg.enable;
          };
        playerCommand = mkOption {
          type = types.str;
          readOnly = true;
          default = "${config.programs.spicetify.spicedSpotify}/bin/spotify";
        };
      };
    };
  };

  config = mkIf (desktopCfg.enable && desktopCfg.music.enable) {
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
