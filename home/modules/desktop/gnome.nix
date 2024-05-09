{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.hopplaos.desktop;

  inherit (lib) types mkOption mkEnableOption Merge mkIf;
  inherit (lib.hm.gvariant) mkTuple;
in {
  options = {
    hopplaos.desktop.gnome = mkEnableOption "Gnome";
  };

  config = {
    home.packages = builtins.attrValues {
      inherit
        (pkgs.gnomeExtensions)
        dash-to-dock
        paperwm
        tray-icons-reloaded
        ;
    };

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = ["brave-browser.desktop" "org.gnome.Nautilus.desktop" "thunderbird.desktop"];
        disable-user-extensions = false;
        enabled-extensions = [
          "dash-to-dock@micxgx.gmail.com"
          "paperwm@paperwm.github.com"
          "trayIconsReloaded@selfmade.pl"
        ];
      };
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
      };
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
        primary-color = "#241f31";
      };
      "org/gnome/desktop/screensaver" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
        primary-color = "#241f31";
      };
      "org/gnome/mutter" = {
        edge-tiling = false;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };
      "org/gnome/desktop/input-sources" = {
        sources = [(mkTuple ["xkb" "us+altgr-intl"]) (mkTuple ["xkb" "de"])];
      };
      "org/gnome/shell/extensions/paperwm" = {
        show-workspace-indicator = false;
        show-window-position-bar = false;
      };
      "org/gnome/shell/extensions/paperwm/keybindings" = {
        new-window = [""];
        close-window = ["<Super>q"];
      };
    };
  };
}
