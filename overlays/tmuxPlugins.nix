{inputs, ...}: {
  flake.overlays.zsa = final: prev: {
    inherit (inputs.unstable.legacyPackages.${final.system}) zsa-udev-rules;
  };
}
