_: {
  flake.overlays.nerdfonts = final: prev: {
    custom-nerdfonts = prev.nerdfonts.override {
      fonts = ["Iosevka" "JetBrainsMono" "Meslo"];
    };
  };
}
