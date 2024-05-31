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
        caffeine
        ;
    };

    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = ["brave-browser.desktop" "org.gnome.Nautilus.desktop" "thunderbird.desktop"];
        disable-user-extensions = false;
        enabled-extensions = [
          "dash-to-dock@micxgx.gmail.com"
          "paperwm@paperwm.github.com"
          "caffeine@patapon.info"
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
      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = ["<Super>F12"];
      };
      "org/gnome/shell/extensions/dash-to-dock" = {
        hot-keys = false;
      };
      "org/gnome/desktop/wm/keybindings" = {
        maximize = [];
        minimize = [];
        move-to-monitor-down = [];
        move-to-monitor-left = [];
        move-to-monitor-right = [];
        move-to-monitor-up = [];
        move-to-workspace-down = [];
        move-to-workspace-left = [];
        move-to-workspace-right = [];
        move-to-workspace-up = [];
        switch-applications = [];
        switch-applications-backward = [];
        switch-group = [];
        switch-group-backward = [];
        switch-panels = [];
        switch-panels-backward = [];
        switch-to-workspace-last = [];
        switch-to-workspace-left = [];
        switch-to-workspace-right = [];
        unmaximize = [];
        move-to-workspace-1 = ["<Shift><Super>1"];
        move-to-workspace-2 = ["<Shift><Super>2"];
        move-to-workspace-3 = ["<Shift><Super>3"];
        move-to-workspace-4 = ["<Shift><Super>4"];
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
      };
      "org/gnome/shell/extensions/paperwm/keybindings" = {
        close-window = ["<Super><Shift>q"];
        move-down = ["<Shift><Super>Down" "<Shift><Super>j"];
        move-left = ["<Control><Super>comma" "<Shift><Super>comma" "<Shift><Super>Left" "<Shift><Super>h"];
        move-monitor-above = ["<Shift><Control><Super>Up" "<Shift><Control><Super>k"];
        move-monitor-below = ["<Shift><Control><Super>Down" "<Shift><Control><Super>j"];
        move-monitor-left = ["<Shift><Control><Super>Left" "<Shift><Control><Super>h"];
        move-monitor-right = ["<Shift><Control><Super>Right" "<Shift><Control><Super>l"];
        move-right = ["<Control><Super>period" "<Shift><Super>period" "<Shift><Super>Right" "<Shift><Super>l"];
        move-space-monitor-above = ["<Shift><Control><Alt>Up" "<Shift><Control><Alt>k"];
        move-space-monitor-below = ["<Shift><Control><Alt>Down" "<Shift><Control><Alt>j"];
        move-space-monitor-left = ["<Shift><Control><Alt>Left" "<Shift><Control><Alt>h"];
        move-space-monitor-right = ["<Shift><Control><Alt>Right" "<Shift><Control><Alt>l"];
        move-up = ["<Shift><Super>Up" "<Shift><Super>k"];
        new-window = [""];
        switch-down = ["<Super>Down" "<Super>j"];
        switch-left = ["<Super>Left" "<Super>h"];
        switch-monitor-above = ["<Control><Super>Up" "<Control><Super>k"];
        switch-monitor-below = ["<Control><Super>Down" "<Control><Super>j"];
        switch-monitor-left = ["<Control><Super>Left" "<Control><Super>h"];
        switch-monitor-right = ["<Control><Super>Right" "<Control><Super>l"];
        switch-right = ["<Super>Right" "<Super>l"];
        switch-up = ["<Super>Up" "<Super>k"];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        binding = "<Super>Return";
        command = cfg.terminalCommand;
        name = "terminal";
      };
    };
  };
}
