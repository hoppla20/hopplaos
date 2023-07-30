{withSystem, ...}: {
  flake.overlays.nerdfonts = final: prev:
    withSystem prev.stdenv.hostPlatform.system ({
      config,
      inputs',
      ...
    }: {
      custom-nerdfonts = prev.nerdfonts.override {
        fonts = ["Iosevka" "JetBrainsMono"];
      };
    });
}
