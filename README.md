# HopplaOS

## Quick Start Installation

```bash
# Enable nix-command and flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
nix run "git+https://gitlab.vincentcui.de/vincent.cui/hopplaos#packages.x86_64-linux.install-system" -- -h
```

When using the provided installer, the package is included:

```bash
install-system -h
```

## Environment Setup

Enable devshell:

```bash
nix [--extra-experimental-features "nix-command flakes"] develop
# or
direnv allow # requires nix-direnv
```

## Build and run test VM for nixosConfiguration

```bash
run-test-vm $CONFIGURATION_NAME
```

## Disko usage

```bash
# SCRIPT: formatScript, mountScript, diskoScript (format + mount)
nix build ".#nixosConfigurations.$CONFIGURATION_NAME.config.system.build.$SCRIPT"
./result
```

## Troubleshooting

### Test VM crashes after bootloader

[Bug](https://gitlab.com/qemu-project/qemu/-/issues/1727) in qemu virtio-gpu-gl.
Switch between virtio-vga and virtio-vga-gl to work around this issue
(ctrl-alt-2, ctrl-alt-1).

## Builds Upon

### Flake Parts

- [GitHub](https://github.com/hercules-ci/flake-parts)
- [Docs](https://flake.parts)
