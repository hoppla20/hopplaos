{ pkgs, inputs', ... }:
pkgs.writeShellScriptBin "install-system" ''
  set -o errexit
  set -o nounset
  set -o pipefail

  set -x

  pos_args=()
  disko_enable=0
  disko_mode="disko"
  hopplaos_flake="git+https://gitlab.vincentcui.de/vincent.cui/hopplaos"

  usage() {
    cat <<-EOF
  Usage: install-system [-h] [-d] [-m] [name]

  Flags:
    -h : show this usage
    -d : use disko configuration to format and mount the disks and filesystems
    -m : use disko's mount mode instead of format + mount

  Options:
    name : configuration name
  EOF
  }

  parse_args() {
    while [ "$OPTIND" -le "$#" ]; do
      if getopts "hdm" flag; then
        case "$flag" in
          d) disko_enable=1;;
          m) disko_mode="mount";;
          h) usage && exit 0;;
          *) usage && exit 1;;
        esac
      else
        pos_args+=("''${!OPTIND}")
        ((OPTIND++))
      fi
    done
  }

  main() {
    parse_args "$@"
    configuration_name="''${pos_args[0]}"

    if [ $disko_enable -eq 1 ]; then
      sudo ${inputs'.disko.packages.default}/bin/disko --mode "$disko_mode" --flake "$hopplaos_flake#$configuration_name"
    fi

    sudo nixos-install \
      --flake "$hopplaos_flake#$configuration_name" \
      --no-channel-copy \
      --no-root-password
  }

  main "$@"
''
