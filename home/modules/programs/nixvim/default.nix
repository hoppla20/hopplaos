{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.programs.nixvim-desktop;
in {
  options.hopplaos.programs.nixvim-desktop = {
    enable = mkEnableOption "nixvim";
  };

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) {
    xdg.dataFile."applications/nixvim.desktop".text = ''
      [Desktop Entry]
      Name=NixVim
      Exec=${config.hopplaos.desktop.terminalCommand} -e nvim
      Type=Application
      Icon=nvim
      MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
      Categories=Utility;TextEditor;
    '';
  };
}
