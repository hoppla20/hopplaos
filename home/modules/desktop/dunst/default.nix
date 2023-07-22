{ pkgs, config, lib, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.dunst;
in
{
  options = {
    hopplaos.desktop.dunst = {
      enable = mkEnableOption "Dunst" // { default = desktopCfg.enable; };
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
          width = "(150, 400)";
          height = 300;
          origin = "top-right";
          offset = "5x5";
          corner_radius = 10;
          gap_size = 5;

          progress_bar = true;
          progress_bar_height = 5;
          progress_bar_min_width = 150;
          progress_bar_max_width = 400;
          progress_bar_frame_width = 1;
          progress_bar_corner_radius = 10;

          horizontal_padding = 10;
          frame_width = 1;
          idle_threshold = 120;

          font = "${config.gtk.font.name} 10";

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

        urgency_low.timeout = 3;
        urgency_normal.timeout = 6;
        urgency_critical.timeout = 0;
      };

      extraConfig = builtins.readFile (config.scheme inputs.base16-dunst);
    };
  };
}
