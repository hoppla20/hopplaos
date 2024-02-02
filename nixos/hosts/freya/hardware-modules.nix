{inputs, ...}: [
  inputs.nixos-hardware.nixosModules.common-cpu-intel # igpu included
  inputs.nixos-hardware.nixosModules.common-pc-laptop
  inputs.nixos-hardware.nixosModules.common-pc-ssd
]
