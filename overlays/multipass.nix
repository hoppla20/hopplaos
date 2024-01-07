{inputs, ...}: {
  #flake.overlays.multipass = final: prev: {
  #  multipass = prev.multipass.overrideAttrs (finalAttrs: prevAttrs: {
  #    postPatch =
  #      ''
  #        # Patch qemu binary paths
  #        substituteInPlace ./src/platform/backends/libvirt/libvirt_virtual_machine.cpp \
  #          --replace "/usr/bin/qemu" "/run/current-system/sw/bin/qemu"
  #      ''
  #      + prevAttrs.postPatch;

  #    postFixup = ''
  #      patchelf $out/bin/..multipassd-wrapped-wrapped --add-rpath ${final.libvirt}/lib
  #    '';
  #  });
  #};
}
