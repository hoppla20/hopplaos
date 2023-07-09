{
  pkgs,
  config,
  lib,
  ...
}: {
  nix = {
    settings = {
      sandbox = true;
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
      system-features = ["nixos-test" "benchmark" "big-parallel" "kvm"];
    };
    gc.automatic = true;
    optimise.automatic = true;
    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '';
  };
}
