{
  description = "HopplaOS";

  outputs = inputs @ {self, ...}: let
    inherit
      (inputs.flake-parts.lib)
      mkFlake
      ;

    lib = import ./lib {
      lib =
        inputs.nixpkgs.lib
        // {
          flake-utils-plus = inputs.flake-utils-plus.lib;
          digga = inputs.digga.lib;
        };
    };
  in
    mkFlake {inherit inputs;} {
      debug = true;

      imports =
        [
          inputs.devshell.flakeModule
          ./pkgs
          ./nixos
          ./home
        ]
        ++ builtins.attrValues (lib.exportModulesRecursive ./overlays);

      systems = ["x86_64-linux"];

      flake.lib = lib;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        devshells.default = let
          build-installer = pkgs.writeShellScriptBin "build-installer" ''
            nix build .#nixosConfigurations.installer.config.formats.custom-iso
          '';
        in {
          name = "hopplaos";
          packages = [
            pkgs.alejandra
            pkgs.git
            pkgs.neovim
          ];
          commands = [
            {package = self'.packages.repl;}
            {
              package = self'.packages.install-system;
              help = "install-system [-h] [-d] [-m] [name]";
            }
            {
              package = self'.packages.run-test-vm;
              help = "run-test-vm [-h] [-n] [configuration]";
            }
            {package = build-installer;}
          ];
        };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };

    digga = {
      url = "github:divnix/digga/v0.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.latest.follows = "unstable";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators.url = "github:nix-community/nixos-generators";

    disko.url = "github:nix-community/disko";

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eww = {
      url = "github:elkowar/eww";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
}
