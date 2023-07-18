set -o nounset
set -o errexit
set -o pipefail

POS_ARGS=()
CLEAR_TMP=1
INSTALL_ONLY=0

usage() {
  cat <<-EOF
Usage: run-test-vm [-h] [-n] [configuration].

Flags:
  -h : Show this usage.
  -n : Do not destroy previous disk.

Arguments:
  configuration : Name of the nixosConfiguration defined in \`flake.nix\`.
EOF
}

parse_args() {
  while [ "$OPTIND" -le "$#" ]; do
    if getopts "hn" flag; then
      case "$flag" in
        n) CLEAR_TMP=0;;
        h | *) usage && exit 0;;
      esac
    else
      POS_ARGS+=("${!OPTIND}")
      ((OPTIND++))
    fi
  done

  if [ "${#POS_ARGS[@]}" -ne 1 ]; then
    echo "ERROR: Exactly one positional argument is expected. Got ${#POS_ARGS[@]}."
    exit 1
  fi
}

main() {
  parse_args "$@"

  VM_NAME=${POS_ARGS[0]}
  VM_DIR="$PROJ_ROOT/.tmp/vms/$VM_NAME"

  if [ ! "$CLEAR_TMP" -eq 0 ]; then
    rm -rf "$VM_DIR"
  fi
  mkdir -p "$VM_DIR"

  nix build \
    -o "$PROJ_ROOT/result"  \
    "$PROJ_ROOT#nixosConfigurations.$VM_NAME.config.formats.vm-bootloader"

  export NIX_DISK_IMAGE="$VM_DIR/rootDisk.qcow2"
  export NIX_EFI_VARS="$VM_DIR/efi-vars.fd"
  bash "$PROJ_ROOT/result/bin/run-$VM_NAME-vm"
}

main "$@"
