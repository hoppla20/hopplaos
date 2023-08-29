{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.hopplaos.programs.vscode;

  extensions =
    (with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc

      jnoortheen.nix-ide
      redhat.vscode-yaml
      ms-python.python
      yzhang.markdown-all-in-one
      ms-vscode.cpptools
      james-yu.latex-workshop

      ms-azuretools.vscode-docker
      ms-kubernetes-tools.vscode-kubernetes-tools
      ms-vscode-remote.remote-ssh
      donjayamanne.githistory
      esbenp.prettier-vscode
      gruntfuggly.todo-tree
      asvetliakov.vscode-neovim
      editorconfig.editorconfig
      stkb.rewrap
      valentjn.vscode-ltex
      editorconfig.editorconfig
      hashicorp.terraform
      mkhl.direnv
    ])
    ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace
    (import ./marketplaceExtensions.nix);
in {
  options = {
    hopplaos.programs.vscode = {enable = mkEnableOption "VSCode";};
  };

  config = mkIf cfg.enable {
    hopplaos.desktop.editorCommand = "${config.programs.vscode.package}/bin/codium";

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableExtensionsDir = false;
      inherit extensions;
      userSettings = {
        # appearance
        "workbench.colorTheme" =
          if config.hopplaos.desktop.darkTheme
          then "Catppuccin Macchiato"
          else "Catppuccin Latte";
        "editor.fontFamily" = "'JetBrainsMono Nerd Font'";
        "editor.minimap.enabled" = false;
        "editor.rulers" = [80];
        "editor.stickyScroll.enabled" = true;

        # behavior
        "editor.tabSize" = 2;
        "update.mode" = "none";
        "keyboard.dispatch" = "keyCode";
        "editor.acceptSuggestionOnEnter" = "off";
        "editor.acceptSuggestionOnCommitCharacter" = false;
        "explorer.autoReveal" = false;
        "git.confirmSync" = false;
        "extensions.autoUpdate" = false;
        "terminal.integrated.commandsToSkipShell" = ["-workbench.action.quickOpen"];

        # plugin settings
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };
        "vscode-neovim.neovimExecutablePaths.linux" = "/run/current-system/sw/bin/nvim";
        "redhat.telemetry.enabled" = false;
        "latex-workshop.view.pdf.viewer" = "tab";
        "latex-workshop.synctex.synctexjs.enabled" = true;
        "hediet.vscode-drawio.theme" = "atlas";
        "vs-kubernetes" = {"vs-kubernetes.crd-code-completion" = "enabled";};
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          "nil" = {
            "formatting" = {
              "command" = ["alejandra"];
            };
            "diagnostics" = {
              "ignored" = ["unused_binding"];
            };
          };
        };
        "nix.formatterPath" = "alejandra";

        # language settings
        "[jsonc]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
        "[yaml]" = {"editor.defaultFormatter" = "esbenp.prettier-vscode";};
      };
    };
  };
}
