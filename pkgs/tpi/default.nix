{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "tpi";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "turing-machines";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eEWGyXNUPDoC0y543FDUkdxPnpCy0hW9doYcuHeN0F0=";
  };

  cargoHash = "sha256-W7jBWaX5dA1YymAJLs+ljuQxNW96tZUmgvdo6lJsUSw=";
}
