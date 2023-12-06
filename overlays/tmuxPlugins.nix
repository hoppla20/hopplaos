{inputs, ...}: {
  flake.overlays.tmuxPlugins = final: prev: {
    inherit (inputs.unstable.legacyPackages.${final.system}) tmuxPlugins;
  };
}
