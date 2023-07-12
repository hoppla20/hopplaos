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

    fonts.fontconfig.enable = true;
    gtk = {
      enable = true;
      theme = {
        name = "Orchis-Purple-Dark";
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    services.gnome-keyring.enable = true;

    xdg.configFile = {
      "wallpapers/wallpaper.jpg".source = ./wallpaper.jpg;
    };
  };
}
