{
  self,
  inputs,
  withSystem,
  ...
}: {
  flake.nixOnDroidConfigurations.default =
    withSystem "aarch64-linux" ({
      pkgs,
      pkgs-unstable,
      self',
      inputs',
      ...
    }: inputs.nix-on-droid.lib.nixOnDroidConfiguration {
      modules = [
        ({config, ...}: let
          sshdTmpDirectory = "${config.user.home}/sshd-tmp";
          sshdDirectory = "${config.user.home}/.config/sshd";
          sshPort = 8022;
        in {
          environment.packages = builtins.attrValues {
            inherit
              (pkgs)
              which
              dnsutils
              grep
              ripgrep
              openssh
              nix-output-monitor
              ;
          } ++ [
            (pkgs.writeScriptBin "sshd-start" ''
              #!${pkgs.runtimeShell}

              echo "Starting sshd in non-daemonized way on port ${toString sshPort}"
              ${pkgs.openssh}/bin/sshd -f "${sshdDirectory}/sshd_config" -D
            '')
          ];

          build.activation.sshd = ''
            $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${config.user.home}/.ssh"

            if [[ ! -d "${sshdDirectory}" ]]; then
              $DRY_RUN_CMD rm $VERBOSE_ARG --recursive --force "${sshdTmpDirectory}"
              $DRY_RUN_CMD mkdir $VERBOSE_ARG --parents "${sshdTmpDirectory}"

              $VERBOSE_ECHO "Generating host keys..."
              $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -f "${sshdTmpDirectory}/ssh_host_rsa_key" -N ""

              $VERBOSE_ECHO "Writing sshd_config..."
              $DRY_RUN_CMD echo -e "HostKey ${sshdDirectory}/ssh_host_rsa_key\nPort ${toString sshPort}\n" > "${sshdTmpDirectory}/sshd_config"

              $DRY_RUN_CMD mv $VERBOSE_ARG "${sshdTmpDirectory}" "${sshdDirectory}"
            fi
          '';

          home-manager = {
            useGlobalPkgs = true;
            extraSpecialArgs = {inherit inputs self inputs' self' pkgs-unstable;};
            config = self.homeConfigurations.nix-on-droid;
          };

          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          time.timeZone = "Europe/Amsterdam";
          system.stateVersion = "23.05";
        })
      ];
    });
}
