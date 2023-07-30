{pkgs, ...}:
pkgs.writeShellScriptBin "run-test-vm" (builtins.readFile ./script.sh)
