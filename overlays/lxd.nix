{inputs, ...}: {
  flake.overlays.incus = final: prev: {
    inherit
      (inputs.unstable.legacyPackages.${final.system})
      lxd
      incus
      lxc
      lxcfs
      ;
  };
}
