{
  pkgs-unstable,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.programs.notetaking;

  logseqPkg = pkgs-unstable.logseq;
  obsidianPkg = pkgs-unstable.obsidian;
in {
  options.hopplaos.programs.notetaking = {
    enable = mkEnableOption "Note Taking";
  };

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) {
    home.packages = [logseqPkg obsidianPkg];

    xdg.dataFile."applications/logseq-wayland.desktop".text = ''
      [Desktop Entry]
      Name=Logseq Wayland
      Exec=logseq --ozone-platform-hint=wayland --enable-wayland-ime --enable-features=WaylandWindowDecorations %u
      Terminal=false
      Type=Application
      Icon=logseq
      StartupWMClass=Logseq
      X-AppImage-Version=${logseqPkg.version}
      Comment=A privacy-first, open-source platform for knowledge management and collaboration.
      MimeType=x-scheme-handler/logseq
      Categories=Utility
    '';
  };
}
