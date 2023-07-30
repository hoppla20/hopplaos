{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    ;

  desktopCfg = config.hopplaos.desktop;
  cfg = config.hopplaos.programs.theme-switcher;

  script = pkgs.writeShellScript "theme-switcher" ''
    case "$ROFI_RETV" in
      0)
        echo -en "\0prompt\x1fTheme Switcher\n"
        echo -en "\0no-custom\x1ftrue\n"
        echo -en "\0theme\x1f@theme \"theme-alt\"\n"
        ls -1 /nix/var/nix/profiles/system/specialisation
        ;;
      1)
        coproc ( nix-specialisation-switcher "$1" >/dev/null 2>&1 )
        ;;
      *)
        exit 1
        ;;
    esac
  '';
in {
  options.hopplaos.programs.theme-switcher = {
    enable =
      mkEnableOption "Theme switcher"
      // {
        default = desktopCfg.enable;
      };
    package = mkOption {
      type = types.package;
      default = pkgs.writeShellScriptBin "theme-switcher" ''
        ${config.programs.rofi.package}/bin/rofi -show theme-switcher -modes "theme-switcher:${script}"
      '';
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [cfg.package];
  };
}
