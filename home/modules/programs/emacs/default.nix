{
  pkgs,
  config,
  lib,
  inputs,
  inputs',
  ...
}: let
  l = lib // builtins;

  cfg = config.hopplaos.programs.emacs;
  inherit (config.hopplaos.desktop) darkTheme;
  catppuccinTheme =
    if darkTheme
    then "macchiato"
    else "latte";
in {
  options.hopplaos.programs.emacs.enable = lib.mkEnableOption "Emacs";

  config = lib.mkIf cfg.enable {
    hopplaos.desktop.editorCommand = "${config.programs.emacs.finalPackage}/bin/emacsclient --create-frame";

    programs.emacs = {
      enable = true;
      package = inputs'.hoppla-emacs.packages.hoppla-emacs;
    };

    services.emacs = {
      enable = true;
      client.enable = true;
      defaultEditor = true;
      socketActivation.enable = true;
    };

    home.packages = l.attrValues inputs.hoppla-emacs.dependencies.${pkgs.system};

    xdg.configFile."emacs/etc/user.el".text = ''
      (setq hoppla/catppuccin-flavor '${catppuccinTheme})
      (setq hoppla/extra-workspace-dirs '(("/etc/nixos" . 0)
                                          ("~/.config/emacs" . 0)))
    '';

    programs.bash.initExtra = l.readFile "${inputs.emacs-libvterm}/etc/emacs-vterm-bash.sh";
    programs.zsh.initExtra = l.readFile "${inputs.emacs-libvterm}/etc/emacs-vterm-zsh.sh";
  };
}
