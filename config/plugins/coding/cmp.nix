{
  plugins = {
    cmp-buffer.enable = true;
    cmp-cmdline.enable = true;
    cmp-emoji.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = true;
    cmp-treesitter.enable = true;
    cmp-git.enable = true;
    cmp-npm.enable = true;
    copilot-cmp.enable = true;
    copilot-lua = {
      enable = true;
      suggestion.enabled = false;
      panel.enabled = false;
      filetypes = {
        markdown = true;
        help = true;
      };
    };

    cmp = {
      enable = true;
      settings = {
        autoEnableSources = true;
        experimental = {
          ghost_text = {
            hl_group = "CmpGhostText";
          };
        };
        performance = {
          debounce = 150;
          fetchingTimeout = 500;
          maxViewEntries = 30;
        };
        snippet.expand =
          # lua
          ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        sources = [
          {name = "nvim_lsp";}
          {
            name = "npm";
            keyword_length = 4;
          }
          {
            name = "path";
            keywordLength = 3;
          }
          {name = "emoji";}
          {
            name = "copilot";
            keywordLength = 5;
          }
          {name = "treesitter";}
          {
            name = "luasnip";
            keywordLength = 3;
          }
          {
            name = "buffer";
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
            keywordLength = 3;
          }
        ];
        formatting = {
          fields = ["abbr" "kind" "menu"];
        };

        completion = {
          completeopt = "menu,menuone,noinsert";
        };

        window = {
          completion = {
            scrollbar = false;
            sidePadding = 0;
            border = "rounded";
          };

          settings.documentation = {
            border = "rounded";
          };
        };

        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })";
          "<C-p>" = "cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })";
          "<Down>" = "cmp.mapping.select_next_item()";
          "<Up>" = "cmp.mapping.select_prev_item()";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" =
            # lua
            ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  if require("luasnip").expandable() then
                    require("luasnip").expand()
                  else
                    cmp.confirm({select = true})
                  end
                else
                  fallback()
                end
              end)
            '';
          "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          "<C-CR>" =
            # lua
            ''
              function(fallback)
                cmp.abort()
                fallback()
              end
            '';
          "<Tab>" =
            # lua
            ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require("luasnip").expand_or_locally_jumpable() then
                  require("luasnip").expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s"})
            '';
          "<S-Tab>" =
            # lua
            ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require("luasnip").locally_jumpable(-1) then
                  require("luasnip").jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
        };
      };
    };
  };
  extraConfigLuaPre =
    # lua
    ''
      function has_words_before()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
    '';

  extraConfigLua =
    # lua
    ''
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })

      -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({'/', "?" }, {
        sources = {
          { name = 'buffer' }
        }
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources(
          {
            { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
          },
          {
            { name = 'buffer' },
          }
        )
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources(
          {
            { name = 'path' }
          },
          {
            { name = 'cmdline' }
          }
        ),
      })
    '';
}
