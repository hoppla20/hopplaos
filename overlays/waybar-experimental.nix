_: {
  flake.overlays.waybar-experimental = final: prev: {
    waybar-experimental = prev.waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    });
  };
}
