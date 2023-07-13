# HopplaOS

## Environment Setup

Enable devshell:

```bash
nix develop
# or
direnv allow
```

## Build and run test VM for nixosConfiguration

```bash
run-test-vm $CONFIGURATION_NAME
```

## Disko usage

```bash
# SCRIPT: formatScript, mountScript, diskoScript (format + mount)
nix build .#nixosConfigurations.$CONFIGURATION_NAME.config.system.build.$SCRIPT
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
