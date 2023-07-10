{
  withSystem,
  inputs,
  self,
  ...
}: let
  nixosModules = self.lib.exportModulesRecursive ./modules;
in {
  flake = {
    nixosConfigurations = withSystem "x86_64-linux" ({
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
            inherit inputs inputs';
            homeUsers = self.homeManagerConfigurations;
          };
          modules =
            builtins.attrValues nixosModules
            ++ [
              inputs.nixos-generators.nixosModules.all-formats
              inputs.home-manager.nixosModules.default
              dir
              {networking.hostName = name;}
            ];
        };
    in
      inputs.nixpkgs.lib.mapAttrs mkHost (self.lib.listDirectoryModules ./hosts));
    nixosModules = nixosModules;
  };
}
