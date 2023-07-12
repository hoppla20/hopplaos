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

  brightnessStep = 10;
in {
  options = {
    hopplaos.desktop = {
      enable = mkEnableOption "HopplaOS Desktop";

      polkitAgent = mkOption {
        type = types.str;
        readOnly = true;
        default = "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1";
      };

      systemCommands = {
        lock = mkOption {
          type = types.str;
          default = "${pkgs.systemd}/bin/loginctl lock-session";
        };
        suspend = mkOption {
          type = types.str;
          default = "${pkgs.systemd}/bin/systemctl suspend";
        };
        hibernate = mkOption {
          type = types.str;
          default = "${pkgs.systemd}/bin/systemctl hibernate";
        };
        reboot = mkOption {
          type = types.str;
          default = "${pkgs.systemd}/bin/systemctl reboot";
        };
        poweroff = mkOption {
          type = types.str;
          default = "${pkgs.systemd}/bin/systemctl poweroff";
        };
      };
      appLauncherCommand = mkOption {
        type = types.str;
        readOnly = true;
      };
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
      brightnessControlCommands = {
        raise = mkOption {
          type = types.str;
          readOnly = true;
          default = "light -A ${toString brightnessStep}";
        };
        lower = mkOption {
          type = types.str;
          readOnly = true;
          default = "light -U ${toString brightnessStep}";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    hopplaos.desktop.browserCommand = "${pkgs.brave}/bin/brave --use-angle=vulkan --use-cmd-decoder=passthrough";

    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        xdg-utils
        glib
        brave
        light
        ;

      inherit
        (pkgs.xorg)
        xhost
        ;
    };

    fonts.fontconfig.enable = true;
    gtk = {
      enable = true;
      font = {
        name = "FiraCode Nerd Font";
        package = pkgs.custom-nerdfonts;
      };
      theme = {
        name = "Orchis-Purple-Dark";
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
      };
    };

    services.gnome-keyring.enable = true;

    xdg.configFile = {
      "wallpapers/wallpaper.jpg".source = ./wallpaper.jpg;
    };
  };
}
