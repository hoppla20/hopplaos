{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.hopplaos.programs.tmux;
  inherit (config.hopplaos.desktop) darkTheme;
in {
  options.hopplaos.programs.tmux.enable = mkEnableOption "Programs - tmux";

  config = mkIf cfg.enable {
    programs = {
      tmux = {
        enable = true;

        prefix = "C-Space";
        terminal = "tmux-256color";
        keyMode = "emacs";
        sensibleOnTop = true;
        baseIndex = 1;
        mouse = true;
        clock24 = true;
        tmuxp.enable = true;

        plugins = [
          {
            plugin = pkgs.tmuxPlugins.catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavour '${
                if darkTheme
                then "macchiato"
                else "latte"
              }'

              set -g @catppuccin_user "on"
              set -g @catppuccin_host "on"
              set -g @catppuccin_pill_theme_enabled on
              set -g @catppuccin_window_tabs_enabled on
            '';
          }
          {
            plugin = pkgs.tmuxPlugins.better-mouse-mode;
            extraConfig = ''
              set -g @scroll-down-exit-copy-mode "off"
              set -g @scroll-without-changing-pane "on"
              set -g @scroll-in-moused-over-pane "on"
            '';
          }
          {plugin = pkgs.tmuxPlugins.yank;}
          {plugin = pkgs.tmuxPlugins.sessionist;}
        ];

        extraConfig = ''
          # truecolor
          set -ag terminal-overrides ",$TERM:RGB"

          # tmux-nvim
          is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
          bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' { if -F '#{pane_at_left}' ''' 'select-pane -L' }
          bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' { if -F '#{pane_at_bottom}' ''' 'select-pane -D' }
          bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' { if -F '#{pane_at_top}' ''' 'select-pane -U' }
          bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' { if -F '#{pane_at_right}' ''' 'select-pane -R' }
          bind-key -T copy-mode-vi 'C-h' if -F '#{pane_at_left}' ''' 'select-pane -L'
          bind-key -T copy-mode-vi 'C-j' if -F '#{pane_at_bottom}' ''' 'select-pane -D'
          bind-key -T copy-mode-vi 'C-k' if -F '#{pane_at_top}' ''' 'select-pane -U'
          bind-key -T copy-mode-vi 'C-l' if -F '#{pane_at_right}' ''' 'select-pane -R'
          bind-key -n 'M-h' if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 1'
          bind-key -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 1'
          bind-key -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 1'
          bind-key -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 1'
          bind-key -T copy-mode-vi M-h resize-pane -L 1
          bind-key -T copy-mode-vi M-j resize-pane -D 1
          bind-key -T copy-mode-vi M-k resize-pane -U 1
          bind-key -T copy-mode-vi M-l resize-pane -R 1
        '';
      };

      zsh.prezto.pmodules = lib.mkOrder 2000 ["tmux"];
      fzf.tmux.enableShellIntegration = true;
    };

    xdg.configFile."tmux/sessions".source = ./sessions;
    home.shellAliases.tmuxe = "tmuxp load ~/.config/tmux/sessions/nvim-current.yaml";
  };
}
