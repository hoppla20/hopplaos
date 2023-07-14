{
  pkgs,
  config,
  lib,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = ["ntfs"];
    kernel.sysctl = {
      "vm.swappiness" = 10;
    };
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
    supportedLocales = ["de_DE.UTF-8/UTF-8"];
  };

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
    starship.enable = true;
    dconf.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;

  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  environment = {
    pathsToLink = [
      "/share/nix-direnv"
      "/share/zsh"
    ];
    systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        coreutils
        dnsutils
        iputils
        pciutils
        usbutils
        # utils
        
        htop
        bottom
        # system monitoring
        
        parted
        gptfdisk
        # partitioning
        
        bat
        curl
        direnv
        nix-direnv
        wget
        git
        jq
        yq
        neovim
        pv
        ripgrep
        # useful tools
        
        niv
        # nix tools
        
        ;
    };

    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../../";
    };
  };

  documentation = {
    man.enable = true;
    doc.enable = false;
  };

  system.stateVersion = lib.mkDefault "23.05";
}
