{
  perSystem = {pkgs, ...}: {
    packages = {
      repl = pkgs.callPackage ./repl {};
      pulseaudio-control = pkgs.callPackage ./pulseaudio-control {};
    };
  };
}
