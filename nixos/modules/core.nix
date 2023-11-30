{
  pkgs,
  config,
  lib,
  ...
}: {
  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    supportedFilesystems = ["ntfs"];
    kernel.sysctl = {"vm.swappiness" = 10;};
  };

  console = {
    keyMap = lib.mkDefault "us";
    useXkbConfig = true;
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    xkbOptions = "caps:escape";
  };

  time.timeZone = lib.mkDefault "Europe/Berlin";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["C.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8"];
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    dconf.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  environment = {
    pathsToLink = ["/libexec" "/share/nix-direnv" "/share/zsh"];
    systemPackages =
      builtins.attrValues {
        inherit
          (pkgs)
          # utils

          coreutils
          dnsutils
          iputils
          pciutils
          usbutils
          expect
          # system monitoring

          htop
          bottom
          # partitioning

          parted
          gptfdisk
          # useful tools

          zip
          unzip
          gzip
          gnutar
          # archives

          bat
          curl
          wget
          git
          jq
          yq
          pv
          ripgrep
          gawk
          gnused
          killall
          rename
          openssl
          tldr
          # nix tools

          niv
          nil
          alejandra
          nix-output-monitor
          statix
          nix-tree
          nvd
          nix-diff
          ;
      }
      ++ [
        (pkgs.writeShellScriptBin "nix-specialisation-switcher" ''
          sudo "/nix/var/nix/profiles/system/specialisation/$1/bin/switch-to-configuration" switch
        '')
      ];
  };

  documentation = {
    man.enable = true;
    doc.enable = false;
  };

  system = {
    activationScripts.diff = {
      supportsDryActivation = true;
      text = ''
        if [[ -e /run/current-system ]]; then
          PATH="${pkgs.nix}/bin:$PATH"

          echo -e "\n***            ***          ***           ***           ***\n"
          ${pkgs.nvd}/bin/nvd diff /run/current-system "$systemConfig"
          echo -e "\n***            ***          ***           ***           ***\n"
        fi
      '';
    };

    stateVersion = lib.mkDefault "23.05";
  };
}
