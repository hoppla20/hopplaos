{ pkgs, config, lib, inputs, self, ... }: {
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    settings = {
      sandbox = true;
      auto-optimise-store = true;
      allowed-users = [ "@wheel" ];
      trusted-users = [ "@wheel" ];
    };
    gc.automatic = true;
    optimise.automatic = true;
    extraOptions = ''
      experimental-features = nix-command flakes

      keep-outputs = true
      keep-derivations = true

      min-free = 536870912
      fallback = true
    '';
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = builtins.attrValues self.overlays;
  };
}
