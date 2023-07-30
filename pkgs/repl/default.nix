{writeShellScriptBin}: let
  rootDir = ../..;
in
  writeShellScriptBin "repl" ''
    source /etc/set-environment
    nix repl "${rootDir}/lib/repl.nix" "$@"
  ''
