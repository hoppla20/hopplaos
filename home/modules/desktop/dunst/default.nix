{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.dunst;
in {
  options = {
    hopplaos.desktop.dunst = {
      enable =
        mkEnableOption "Dunst"
        // {
          default = desktopCfg.enable;
        };
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    services.dunst = {
      enable = true;
      iconTheme = {
        name = config.gtk.iconTheme.name;
        package = config.gtk.iconTheme.package;
      };
      settings = {
        global = {
          follow = "keyboard";
          width = "(111, 444)";
          height = 222;
          origin = "top-right";
          offset = "10x10";

          progress_bar_height = 5;
          progress_bar_min_width = 0;
          progress_bar_max_width = 444;
          progress_bar_frame_width = 0;

          transparency = 3;
          horizontal_padding = 11;
          frame_width = 6;
          frame_color = "#3b4252";
          separator_color = "#404859";
          idle_threshold = 120;

          font = "FiraCode Nerd Font 10";

          format = "<span size='x-large' font_desc='FiraCode Nerd Font 9' weight='bold' foreground='#f9f9f9'>%s</span>\\n%b";

          show_age_threshold = 60;
          icon_position = "left";
          max_icon_size = 80;

          sticky_history = false;

          dmenu = "${pkgs.rofi}/bin/rofi -dmenu -p dunst:";

          browser = "${pkgs.brave}/bin/brave";

          mouse_left_click = "close_current";
          mouse_middle_click = "do_action";
          mouse_right_click = "context";

          alignment = "center";
          markup = "full";
          always_run_script = true;
        };

        urgency_low = {
          timeout = 3;
          background = "#3b4252";
          foreground = "#f9f9f9";
          highlight = "#f48ee8";
        };

        urgency_normal = {
          timeout = 6;
          background = "#3b4252";
          foreground = "#f9f9f9";
          highlight = "#f48ee8";
        };

        urgency_critical = {
          timeout = 0;
          background = "#3b4252";
          foreground = "#f9f9f9";
          highlight = "#f48ee8";
        };

        joyful_desktop = {
          appname = "joyful_desktop";
          history_ignore = true;
        };
      };
    };
  };
}
