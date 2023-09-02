{inputs, ...}: {
  flake.overlays.tmuxPlugins = final: prev: {
    tmuxPlugins = inputs.unstable.legacyPackages.${final.system}.tmuxPlugins;
  };
}
