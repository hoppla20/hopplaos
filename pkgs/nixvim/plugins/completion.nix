{pkgs, ...}: {
  extraPackages = [pkgs.fd];
  plugins = {
    luasnip.enable = true;
    nvim-cmp = {
      enable = true;
      snippet.expand = "luasnip";
      preselect = "None";
      sources = [
        {
          name = "calc";
          groupIndex = 1;
        }
        {
          name = "luasnip";
          groupIndex = 1;
        }
        {
          name = "fuzzy_path";
          groupIndex = 1;
        }
        {
          name = "nvim_lsp";
          groupIndex = 1;
        }
        {
          name = "nvim_lsp_document_symbol";
          groupIndex = 1;
        }
        {
          name = "nvim_lsp_signature_help";
          groupIndex = 1;
        }
        {
          name = "treesitter";
          groupIndex = 2;
        }
        {
          name = "fuzzy_buffer";
          groupIndex = 2;
        }
      ];
      mappingPresets = ["insert"];
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = false })";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
      };
    };

    cmp-cmdline.enable = true;
    cmp-cmdline-history.enable = true;
  };

  extraConfigLua = ''
    do
      local cmp = require('cmp')
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          {name = 'fuzzy_buffer'}
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          {name = 'fuzzy_path'},
        }, {
          {name = 'cmdline'},
          {name = 'cmp-cmdline-history'},
        })
      })
    end
  '';
}
