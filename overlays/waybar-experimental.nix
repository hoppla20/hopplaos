{ withSystem, ... }: {
  flake.overlays.waybar-experimental = final: prev:
    withSystem prev.stdenv.hostPlatform.system ({ ... }: {
      waybar-experimental = prev.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    });
}
