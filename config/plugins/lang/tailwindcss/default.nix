{
  config,
  lib,
  ...
}: {
  lsp = {
    servers = {
      tailwindcss = {
        enable = true;
        config = {
          filetypes = ["javascript" "javascriptreact" "typescript" "typescriptreact" "html" "css" "scss" "vue" "svelte" "htmlangular"];
        };
      };
    };
  };

  plugins = {
    tailwind-tools = {
      enable = true;
      settings = {
        document_color = {
          enabled = true;
          kind = "inline";
          inline_symbol = "󰝤 ";
          debounce = 200;
        };
        conceal = {
          symbol = "󱏿";
          highlight = {
            fg = "#38BDF8";
          };
        };
      };
    };

    cmp.settings.formatting.format = let
      cfg = config.plugins.lspkind;
      options = {
        mode = cfg.settings.mode or "symbol";
        maxwidth = {
          menu = 50;
          abbr = 50;
        };
        ellipsis_char = "…";
        show_labelDetails = false;
      };
    in
      lib.mkForce
      # lua
      ''
        function(entry, vim_item)
          local options = ${lib.nixvim.toLuaObject options}
          options.before = require("tailwind-tools.cmp").lspkind_format
          return require('lspkind').cmp_format(options)(entry, vim_item)
        end
      '';
  };
}
