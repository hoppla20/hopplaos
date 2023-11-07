{inputs, ...}: {
  # flake.overlays.multipass = final: prev: {
  #   multipass = prev.multipass.overrideAttrs (finalAttrs: prevAttrs: {
  #     postPatch = ''
  #       # Patch qemu binary paths
  #       substituteInPlace \
  #         ./src/platform/backends/libvirt/libvirt_virtual_machine.cpp \
  #         ./tests/qemu/test_qemu_vm_process_spec.cpp \
  #         ./tests/test_qemuimg_process_spec.cpp \
  #         --replace "/usr/bin/qemu" "/run/current-system/sw/bin/qemu"
  #     '' + prevAttrs.postPatch;

  #     postFixup = ''
  #         patchelf $out/bin/..multipassd-wrapped-wrapped --add-rpath ${final.libvirt}/lib
  #         patchelf $out/bin/.multipass-wrapped --add-rpath ${final.libvirt}/lib
  #     '';
  #   });
  # };

  flake.overlays.multipass = final: prev: {
    multipass = inputs.unstable.legacyPackages.${final.system}.multipass;
  };
}
