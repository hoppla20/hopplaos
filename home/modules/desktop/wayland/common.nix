{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (builtins)
    readDir
    pathExists
    attrNames
    attrValues
    isNull
    ;
  inherit
    (lib)
    mkIf
    filterAttrs
    findFirst
    ;

  cfg = wm: config.hopplaos.desktop.wayland.${wm};

  wms =
    attrNames
    (filterAttrs
      (name: type: type == "directory" && pathExists (./. + "/${name}/default.nix"))
      (readDir ./.));
in {
  config = mkIf (isNull (findFirst (wm: (cfg wm).enable) null wms)) {
    xdg.portal = {
      xdgOpenUsePortal = true;
    };

    home.packages =
      (attrValues {
        inherit
          (pkgs)
          wl-clipboard
          grim
          slurp
          ;

        inherit
          (pkgs.xorg)
          xhost
          ;
      })
      ++ [
        (pkgs.writeShellScriptBin "screenshot-select" "mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date -u +\"%Y-%m-%d_%H-%M-%S_grim.png\")")
        (pkgs.writeShellScriptBin "screenshot" "mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date -u +\"%Y-%m-%d_%H-%M-%S_grim.png\")")
        (pkgs.writeShellScriptBin "screenshot-clip" "grim - | wl-copy")
        (pkgs.writeShellScriptBin "screenshot-select-clip" "grim -g \"$(slurp)\" - | wl-copy")
        (pkgs.writeShellScriptBin "screenshot-window-clip" "grim -g \"$(sway-focused-window-geometry)\" - | wl-copy")
      ];
  };
}
