_: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        keymaps = {
          silent = true;
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };
          lspBuf = {
            " " = "hover";
            "gd" = "definition";
            "gD" = "references";
            "gt" = "type_definitions";
            "gi" = "implementation";
            # rename
            # code_action
          };
        };

        servers = {
          bashls.enable = true;
          pylsp.enable = true;
          nil_ls = {
            enable = true;
            installLanguageServer = false;
            extraOptions.settings = {
              nil = {
                formatting.command = ["alejandra"];
                diagnostics.ignored = ["unused_binding"];
              };
            };
          };

          jsonls.enable = true;
          yamlls.enable = true;
        };
      };
      lspsaga.enable = true;
      lsp-format.enable = true;
      inc-rename.enable = true;
    };
  };
}

