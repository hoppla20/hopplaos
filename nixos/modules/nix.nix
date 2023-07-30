{
  pkgs,
  config,
  lib,
  inputs,
  self,
  ...
}: {
  nix = {
    nixPath = ["nixpkgs=${inputs.nixpkgs}"];
    settings = {
      sandbox = true;
      auto-optimise-store = true;
      allowed-users = ["@wheel"];
      trusted-users = ["@wheel"];
    };
    gc.automatic = true;
    optimise.automatic = true;
    extraOptions = ''
      experimental-features = nix-command flakes

      keep-outputs = true
      keep-derivations = true

      min-free = 5368709120
      fallback = true

      max-jobs = 4
      cores = 8
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = builtins.attrValues self.overlays;
  };
}
