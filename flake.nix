{
  description = "HopplaOS";

  outputs = inputs @ {self, ...}: let
    inherit (builtins) pathExists readDir;

    inherit (inputs.nixpkgs.lib) filterAttrs mapAttrs;

    inherit (inputs.flake-parts.lib) mkFlake;

    lib = import ./lib {
      lib =
        inputs.nixpkgs.lib
        // {
          flake-utils-plus = inputs.flake-utils-plus.lib;
          digga = inputs.digga.lib;
        };
    };

    nixpkgsArgs = {
      config = {
        allowUnfree = true;
        # required by obsidian
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };
      overlays = builtins.attrValues self.overlays;
    };
  in
    mkFlake {inherit inputs;} {
      debug = true;

      imports =
        [inputs.devshell.flakeModule ./pkgs ./nixos ./home]
        ++ builtins.attrValues (lib.exportModulesRecursive ./overlays);

      systems = ["x86_64-linux" "aarch64-linux"];

      flake = {
        inherit lib;
        diskoConfigurations = let
          hostsDir = ./nixos/hosts;
          hostsWithDisko =
            filterAttrs
            (name: type:
              type == "directory" && pathExists (hostsDir + "/${name}/disko.nix"))
            (readDir hostsDir);
        in
          mapAttrs (name: _: import (hostsDir + "/${name}/disko.nix"))
          hostsWithDisko;
      };

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        _module.args = {
          pkgs = import inputs.nixpkgs {
            inherit system;
            inherit (nixpkgsArgs) config overlays;
          };
        };

        legacyPackages = pkgs;
        apps.default.program = "${self'.packages.install-system}/bin/install-system";
        devshells.default = let
          build-installer = pkgs.writeShellScriptBin "build-installer" ''
            nix build .#nixosConfigurations.installer.config.formats.custom-iso
          '';
        in {
          name = "hopplaos";
          packages = [
            pkgs.nil
            pkgs.nvd
            pkgs.nix-output-monitor
            inputs'.disko.packages.default
          ];
          commands = [
            {package = self'.packages.repl;}
            {
              package = pkgs.nix-diff;
              help = "nix-diff <drv path> <drv path> (get drv path with nix-tree)";
            }
            {
              package = pkgs.nvd;
              help = "nvd diff <drv path> <drv path> (get drv path with nix-tree)";
            }
            {
              package = pkgs.statix;
              help = "static {check,fix} .";
            }
            {
              package = pkgs.nix-tree;
              help = "nix-tree --derivation .#nixosConfigurations.$NAME.config.system.build.toplevel";
            }
            {
              name = "nixos-diff";
              command = ''
                #!/usr/bin/env bash
                nixos-rebuild build --flake ".#$(hostname)" && nvd diff /run/current-system result
              '';
            }
            {
              package = self'.packages.install-system;
              help = "install-system [-h] [-d] [-m] [name]";
            }
            {
              package = self'.packages.run-test-vm;
              help = "run-test-vm [-h] [-n] [configuration]";
            }
            {package = build-installer;}
            {
              name = "disko";
              package = pkgs.hello;
              help = ''
                nix build ".#nixosConfigurations.$CONFIGURATION_NAME.config.system.build.{format,mount,disko}Script"'';
            }
            {
              name = "nom-rebuild-switch";
              command = ''
                #!/usr/bin/env bash
                set -o errexit
                set -o pipefail
                git add .
                sudo nixos-rebuild switch |& nom
              '';
              help = "run 'sudo nix run . -- -h' to accept flake extra nix configs";
            }
          ];
        };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
    };

    digga = {
      url = "github:divnix/digga/v0.11.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        latest.follows = "nixpkgs";
        devshell.follows = "devshell";
      };
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-db = {
      url = "github:mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hoppla-nixvim.url = "github:hoppla20/hoppla-nixvim";
    vim-kitty-navigator = {
      url = "github:knubie/vim-kitty-navigator";
      flake = false;
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";

    base16.url = "github:SenchoPens/base16.nix";
    base16-schemes = {
      url = "github:base16-project/base16-schemes";
      flake = false;
    };
    base16-dunst = {
      url = "github:hoppla20/base16-dunst";
      flake = false;
    };
    base16-waybar = {
      url = "github:mnussbaum/base16-waybar";
      flake = false;
    };
    base16-alacritty = {
      url = "github:aarowill/base16-alacritty";
      flake = false;
    };

    ranger-zoxide = {
      url = "github:jchook/ranger-zoxide";
      flake = false;
    };
  };

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://numtide.cachix.org"
      "https://cosmic.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };
}
