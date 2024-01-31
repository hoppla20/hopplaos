{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.hopplaos.desktop;

  inherit (lib) types mkOption mkEnableOption mkIf;

  brightnessStep = 10;
in {
  options = {
    hopplaos.desktop = {
      enable = mkEnableOption "HopplaOS Desktop";
      darkTheme =
        mkEnableOption "System wide dark theme"
        // {
          default = true;
        };
      defaultWallpaper = mkOption {
        type = types.str;
        default =
          if cfg.darkTheme
          then "~/.config/wallpapers/wallpaper-dark.jpg"
          else "~/.config/wallpapers/wallpaper-light.jpg";
      };

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
      };
      terminalCommand = mkOption {
        type = types.str;
      };
      browserCommand = mkOption {
        type = types.str;
        readOnly = true;
        default = "${pkgs.brave}/bin/brave --ozone-platform-hint=auto --enable-webrtc-pipewire-capturer --enable-features=VaapiVideoDecodeLinuxGL";
      };
      editorCommand = mkOption {
        type = types.str;
        default = "${cfg.terminalCommand} -e nvim";
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
    scheme =
      if cfg.darkTheme
      then "${inputs.base16-schemes}/catppuccin-macchiato.yaml"
      else "${inputs.base16-schemes}/catppuccin-latte.yaml";

    xsession.enable = true;

    home = {
      packages = builtins.attrValues {
        inherit
          (pkgs)
          xdg-utils
          glib
          brave
          firefox
          evince
          speedcrunch
          remmina
          ;
        inherit
          (pkgs-unstable)
          anytype
          logseq
          ;
        inherit (pkgs.xorg) xhost;
        inherit (pkgs.gnome) seahorse;
      };

      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      pointerCursor = {
        name = "Bibata-Modern-${
          if cfg.darkTheme
          then "Ice"
          else "Classic"
        }";
        size = 16;
        package = pkgs.bibata-cursors;
        gtk.enable = true;
      };
    };

    fonts.fontconfig.enable = true;

    gtk = {
      enable = true;
      font = {
        name = "Iosevka Nerd Font";
        package = pkgs.custom-nerdfonts;
      };
      theme = {
        name = "Catppuccin-${
          if cfg.darkTheme
          then "Macchiato"
          else "Latte"
        }-Standard-Mauve-${
          if cfg.darkTheme
          then "Dark"
          else "Light"
        }";
        package = pkgs.catppuccin-gtk.override {
          accents = ["mauve"];
          size = "standard";
          tweaks = [];
          variant =
            if cfg.darkTheme
            then "macchiato"
            else "latte";
        };
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
    };

    qt = {
      enable = true;
      platformTheme = "gtk3";
    };

    services.gnome-keyring = {
      enable = false;
      components = ["pkcs11" "secrets" "ssh"];
    };

    xdg = {
      mime.enable = true;
      configFile = {
        "wallpapers".source = ./wallpapers;
      };
    };
  };
}
