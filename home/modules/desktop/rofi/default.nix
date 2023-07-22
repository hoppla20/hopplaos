{ pkgs, config, lib, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.rofi;
in
{
  options = {
    hopplaos.desktop.rofi = {
      enable = mkEnableOption "Rofi";
      wayland = mkEnableOption "Rofi wayland fork" // {
        default = desktopCfg.wayland.enable;
      };
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    hopplaos.desktop.appLauncherCommand =
      "${config.programs.rofi.package}/bin/rofi -show drun";

    xdg.dataFile."rofi/themes/theme-alt.rasi".source = ./theme-alt.rasi;

    programs.rofi = {
      enable = true;
      package = if cfg.wayland then pkgs.rofi-wayland else pkgs.rofi;
      font = "${config.gtk.font.name} 10";
      cycle = true;
      terminal = desktopCfg.terminalCommand;

      # config and theme from https://github.com/adi1090x/rofi
      theme = ./theme.rasi;
      extraConfig = {
        modi = "drun,run,filebrowser";
        case-sensitive = false;
        icon-theme = config.gtk.iconTheme.name;
        matching = "normal";
        tokenize = true;
        ssh-client = "ssh";
        ssh-command = "{terminal} -e {ssh-client} {host} [-p {port}]";
        parse-hosts = true;
        parse-known-hosts = false;
        drun-categories = "";
        drun-match-fields = "name,generic,exec,categories,keywords";
        drun-display-format =
          "{name} [<span weight='light' size='small'><i>({generic})</i></span>]";
        drun-show-actions = false;
        drun-url-launcher = "xdg-open";
        drun-use-desktop-cache = false;
        drun-reload-desktop-cache = false;
        run-command = "{cmd}";
        run-list-command = "";
        run-shell-command = "{terminal} -e {cmd}";
        disable-history = false;
        sorting-method = "normal";
        max-history-size = 25;
        display-run = "Run";
        display-ssh = "SSH";
        display-drun = "Apps";
        display-combi = "Combi";
        display-keys = "Keys";
        display-filebrowser = "Files";
        sort = false;
        threads = 0;
        click-to-exit = true;

        kb-primary-paste = "Control+V,Shift+Insert";
        kb-secondary-paste = "Control+v,Insert";
        kb-clear-line = "Control+w";
        kb-move-front = "Control+a";
        kb-move-end = "Control+e";
        kb-move-word-back = "Alt+b,Control+Left";
        kb-move-word-forward = "Alt+f,Control+Right";
        kb-move-char-back = "Left,Control+b";
        kb-move-char-forward = "Right,Control+f";
        kb-remove-word-back = "Control+Alt+h,Control+BackSpace";
        kb-remove-word-forward = "Control+Alt+d";
        kb-remove-char-forward = "Delete,Control+d";
        kb-remove-char-back = "BackSpace,Shift+BackSpace,Control+h";
        kb-remove-to-eol = "Control+k";
        kb-remove-to-sol = "Control+u";
        kb-accept-entry = "Control+j,Control+m,Return,KP_Enter";
        kb-accept-custom = "Control+Return";
        kb-accept-custom-alt = "Control+Shift+Return";
        kb-accept-alt = "Shift+Return";
        kb-delete-entry = "Shift+Delete";
        kb-mode-next = "Shift+Right,Control+Tab";
        kb-mode-previous = "Shift+Left,Control+ISO_Left_Tab";
        kb-mode-complete = "Control+l";
        kb-row-left = "Control+Page_Up";
        kb-row-right = "Control+Page_Down";
        kb-row-down = "Down,Control+n";
        kb-page-prev = "Page_Up";
        kb-page-next = "Page_Down";
        kb-row-first = "Home,KP_Home";
        kb-row-last = "End,KP_End";
        kb-row-select = "Control+space";
        kb-screenshot = "Alt+S";
        kb-ellipsize = "Alt+period";
        kb-toggle-case-sensitivity = "grave,dead_grave";
        kb-toggle-sort = "Alt+grave";
        kb-cancel = "Escape,Control+g,Control+bracketleft";
        kb-custom-1 = "Alt+1";
        kb-custom-2 = "Alt+2";
        kb-custom-3 = "Alt+3";
        kb-custom-4 = "Alt+4";
        kb-custom-5 = "Alt+5";
        kb-custom-6 = "Alt+6";
        kb-custom-7 = "Alt+7";
        kb-custom-8 = "Alt+8";
        kb-custom-9 = "Alt+9";
        kb-custom-10 = "Alt+0";
        kb-custom-11 = "Alt+exclam";
        kb-custom-12 = "Alt+at";
        kb-custom-13 = "Alt+numbersign";
        kb-custom-14 = "Alt+dollar";
        kb-custom-15 = "Alt+percent";
        kb-custom-16 = "Alt+dead_circumflex";
        kb-custom-17 = "Alt+ampersand";
        kb-custom-18 = "Alt+asterisk";
        kb-custom-19 = "Alt+parenleft";
        kb-select-1 = "Super+1";
        kb-select-2 = "Super+2";
        kb-select-3 = "Super+3";
        kb-select-4 = "Super+4";
        kb-select-5 = "Super+5";
        kb-select-6 = "Super+6";
        kb-select-7 = "Super+7";
        kb-select-8 = "Super+8";
        kb-select-9 = "Super+9";
        kb-select-10 = "Super+0";
        ml-row-left = "ScrollLeft";
        ml-row-right = "ScrollRight";
        ml-row-up = "ScrollUp";
        ml-row-down = "ScrollDown";
        me-select-entry = "MousePrimary";
        me-accept-entry = "MouseDPrimary";
        me-accept-custom = "Control+MouseDPrimary";
      };
    };
  };
}
