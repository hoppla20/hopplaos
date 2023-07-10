{
  description = "HopplaOS";

  outputs = inputs: let
    lib = import ./lib {
      lib =
        inputs.nixpkgs.lib
        // {flake-utils-plus = inputs.flake-utils-plus.lib;}
        // {digga = inputs.digga.lib;};
    };

    inherit
      (inputs.flake-parts.lib)
      mkFlake
      ;
  in
    mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        ./pkgs
        ./nixos
        ./home
      ];

      systems = ["x86_64-linux"];

      debug = true;

      flake.lib = lib;

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;

          imports = [(inputs.digga.lib.importOverlays ./overlays)];
          config = {
            allowUnfree = true;
          };
          overlays = [
            (final: prev: {
              lib = prev.lib.extend (final: prev: {
                hopplaos = lib;
              });
            })
          ];
        };

        devshells.default = {
          name = "hopplaos";
          packages = [
            pkgs.alejandra
            pkgs.git
            pkgs.nixos-generators
            self'.packages.repl
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
