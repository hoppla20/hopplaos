{
  pkgs-unstable,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.programs.logseq;

  pkg = pkgs-unstable.logseq;
in {
  options.hopplaos.programs.logseq = {
    enable = mkEnableOption "LogSeq";
  };

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) {
    home.packages = [pkg];

    xdg.dataFile."applications/logseq-wayland.desktop".text = ''
      [Desktop Entry]
      Name=Logseq Wayland
      Exec=logseq --ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime %u
      Terminal=false
      Type=Application
      Icon=logseq
      StartupWMClass=Logseq
      X-AppImage-Version=${pkg.version}
      Comment=A privacy-first, open-source platform for knowledge management and collaboration.
      MimeType=x-scheme-handler/logseq
      Categories=Utility
    '';
  };
}
