_: {
  plugins = {
    luasnip.enable = true;
    nvim-cmp = {
      enable = true;
      autoEnableSources = true;
      snippet.expand = "luasnip";
      mappingPresets = ["insert" "cmdline"];
    };

    cmp-calc.enable = true;
    cmp-fuzzy-path.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-document-symbol.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
  };
}
