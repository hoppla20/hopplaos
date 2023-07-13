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
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = builtins.attrValues self.overlays;
  };
}
