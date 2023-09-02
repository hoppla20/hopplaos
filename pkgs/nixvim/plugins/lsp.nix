_: {
  plugins = {
    lsp = {
      enable = true;
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
    lspsaga = {
      enable = true;
      hover.openCmd = "!brave";
      rename.autoSave = true;
      lightbulb.sign = false;
    };
    lsp-format.enable = true;
    inc-rename.enable = true;
  };
  maps.normal = let
    silentAction = action: {
      silent = true;
      action = "<CMD>${action}<CR>";
    };
  in {
    "K" = silentAction ":Lspsaga hover_doc";
    "gd" = silentAction ":Lspsaga goto_definition";
    "gD" = silentAction ":Lspsaga finder ref";
    "gi" = silentAction ":Lspsaga finder imp";
    "gt" = silentAction ":Lspsaga goto_type_definition";

    "[d" = silentAction ":Lspsaga diagnostic_jump_prev";
    "]d" = silentAction ":Lspsaga diagnostic_jump_next";

    "<leader>l" = {desc = "lsp";};
    "<leader>la" = silentAction ":Lspsaga code_action";

    "<leader>r" = {desc = "refactoring";};
    "<leader>rn" = silentAction ":Lspsaga rename";
  };
}
