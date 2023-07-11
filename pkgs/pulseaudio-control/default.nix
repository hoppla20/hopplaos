{
  lib,
  stdenv,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation rec {
  name = "pulseaudio-control";
  version = "v2.3.0";

  src = fetchFromGitHub {
    owner = "marioortizmanero";
    repo = "polybar-pulseaudio-control";
    rev = version;
    sha256 = "1k7vf7k3lzywcvn0myjyrjxpybx0kqy9y711baamwi7cfn8r1wy0";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp $src/pulseaudio-control.bash $out/bin/pulseaudio-control
  '';

  meta = {
    homepage = "https://github.com/marioortizmanero/polybar-pulseaudio-control";
    description = "A feature-full Polybar module to control PulseAudio";
    license = lib.licenses.mit;
    platforms = ["x86_64-linux"];
    maintainers = [];
  };
}
