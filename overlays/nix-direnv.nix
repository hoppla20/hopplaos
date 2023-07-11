{withSystem, ...}: {
  flake.overlays.nix-direnv = final: prev:
    withSystem prev.stdenv.hostPlatform.system (
      {
        config,
        inputs',
        ...
      }: {
        nix-direnv = prev.nix-direnv.override {enableFlakes = true;};
      }
    );
}
