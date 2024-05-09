{
  pkgs,
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
      terminalCommand = mkOption {
        type = types.str;
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
          brave
          firefox
          evince
          speedcrunch
          remmina
          thunderbird
          ;
        inherit (pkgs.xorg) xhost;
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
        name = "Ubuntu Nerd Font Propo";
        size = 11;
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

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme =
          if cfg.darkTheme
          then "prefer-dark"
          else "default";
      };
    };

    qt = {
      enable = true;
      platformTheme.name =
        if cfg.gnome
        then "gnome"
        else "gtk3";
    };

    services.gnome-keyring = {
      enable = false;
      components = ["pkcs11" "secrets" "ssh"];
    };

    xdg.configFile = let
      gtk4Dir = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0";
    in {
      "wallpapers".source = ./wallpapers;
      "gtk-4.0/assets".source = "${gtk4Dir}/assets";
      "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
    };
  };
}
