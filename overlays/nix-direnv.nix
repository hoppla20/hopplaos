_: {
  flake.overlays.nix-direnv = final: prev: {
    nix-direnv = prev.nix-direnv.override {enableFlakes = true;};
  };
}
