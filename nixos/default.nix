{
  withSystem,
  inputs,
  self,
  ...
}: let
  nixosModules = self.lib.exportModulesRecursive ./modules;
in {
  flake = {
    nixosConfigurations =
      withSystem "x86_64-linux"
      ({
        config,
        self',
        inputs',
        system,
        ...
      }: let
        mkHost = name: dir:
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit inputs inputs' self self';
            };
            modules =
              builtins.attrValues nixosModules
              ++ [
                {networking.hostName = name;}
                inputs.nixos-generators.nixosModules.all-formats
                inputs.home-manager.nixosModules.default
                inputs.disko.nixosModules.default
                inputs.nixos-cosmic.nixosModules.default
                dir
              ]
              ++ import (dir + "/hardware-modules.nix") {inherit inputs;};
          };
      in
        inputs.nixpkgs.lib.mapAttrs mkHost
        (self.lib.listDirectoryModules ./hosts));
    inherit nixosModules;
  };
}
