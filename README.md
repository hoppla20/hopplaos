# HopplaOS

## Environment Setup

Enable devshell:

```bash
nix develop
# or
direnv allow
```

## Build Test VM

```bash
nix build .#nixosConfigurations.$HOSTNAME.config.formats.vm-bootloader
./result/bin/run-nixos-vm
```

## Builds Upon

### Flake Parts

- [GitHub](https://github.com/hercules-ci/flake-parts)
- [Docs](https://flake.parts)
