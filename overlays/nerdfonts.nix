_: {
  flake.overlays.nerdfonts = final: prev: {
    custom-nerdfonts = prev.nerdfonts.override {
      fonts = ["Ubuntu" "JetBrainsMono"];
    };
  };
}
