# HopplaOS

## Quick Start

```bash
# Enable nix-command and flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
nix run "git+https://gitlab.vincentcui.de/vincent.cui/hopplaos -- -h
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
nix run github:nix-community/disko -- -m {format,mount,disko} -f "git+https://gitlab.vincentcui.de/vincent.cui/hopplaos#$CONFIGURATION_NAME"
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

# Tips & Tricks

## Switch between dark and light theme

```bash
nix-specialisation-switch [dark,light]
```
