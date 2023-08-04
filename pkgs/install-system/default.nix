{
  pkgs,
  inputs',
  ...
}:
pkgs.writeShellScriptBin "install-system" ''
  set -o errexit
  set -o nounset
  set -o pipefail

  pos_args=()
  disko_enable=0
  disko_mode="disko"
  hopplaos_flake="git+https://gitlab.vincentcui.de/vincent.cui/hopplaos"
  debug=0

  usage() {
    cat <<-EOF
  Usage: install-system [-v] [-h] [-d] [-m] [name]

  Flags:
    -v : debug
    -h : show this usage
    -d : use disko configuration to format and mount the disks and filesystems
    -m : use disko's mount mode instead of format + mount

  Options:
    name : configuration name
  EOF
  }

  parse_args() {
    while [ "$OPTIND" -le "$#" ]; do
      if getopts "hdmv" flag; then
        case "$flag" in
          d) disko_enable=1;;
          m) disko_mode="mount";;
          h) usage && exit 0;;
          v) debug=1;;
          *) usage && exit 1;;
        esac
      else
        pos_args+=("''${!OPTIND}")
        ((OPTIND++))
      fi
    done

    if [ "''${#pos_args[@]}" -ne 1 ]; then
      echo "error: missing configuration name\n"
      usage
      exit 1
    fi
  }

  main() {
    parse_args "$@"
    configuration_name="''${pos_args[0]}"

    if [ "$debug" -eq 1 ]; then
      set -x
    fi

    if [ "$disko_enable" -eq 1 ]; then
      sudo ${inputs'.disko.packages.default}/bin/disko --mode "$disko_mode" --flake "$hopplaos_flake#$configuration_name"
    fi

    sudo nixos-install \
      --flake "$hopplaos_flake#$configuration_name" \
      --no-channel-copy \
      --no-root-password
  }

  main "$@"
''
