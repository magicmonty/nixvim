{
  plugins.lsp = {
    enable = true;

    servers = {
      bashls.enable = true;
      clangd.enable = true;
      tsserver = {
        enable = true;
        onAttach.function =
          # lua
          ''
            vim.keymap.set(
              "n",
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize imports",
            )
            vim.keymap.set(
              "n",
              "<leader>cR",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Remove unused imports",
            )
          '';
        settings = {
          completions.completeFunctionCalls = true;
        };
      };
      lua-ls = {
        enable = true;
        settings.telemetry.enable = false;
      };
      nil_ls.enable = true;
      dockerls.enable = true;
      docker-compose-language-service.enable = true;
      marksman.enable = true;
      tailwindcss = {
        enable = true;
        settings = {
          filetypes = ["javascript" "javascriptreact" "typescript" "typescriptreact" "html" "css" "scss" "vue" "svelte"];
        };
      };
      texlab = {
        enable = true;
        onAttach.function =
          # lua
          ''
            vim.keymap.set("n", "<leader>K", "<plug>(vimtex-doc-package)", desc = "Vimtex docs", silent = true)
          '';
      };
      yamlls = {
        enable = true;
        extraOptions = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false;
                lineFollowing = false;
              };
            };
          };
          # lazy-load schemastore when needed
          on_new_config = {
            __raw =
              # lua
              ''
                function(new_config)
                  new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                    "force",
                    new_config.settings.yaml.schemas or {},
                    require("schemastore").yaml.schemas()
                  )
                end
              '';
          };
        };
        settings = {
          redhat.telemetry.enabled = false;
          yaml = {
            keyOrdering = false;
            format.enable = true;
            validate = true;
            schemaStore = {
              enable = false;
              url = "";
            };
          };
        };
      };
    };

    keymaps = {
      diagnostic = {
        "äd" = "goto_next";
        "öd" = "goto_prev";
      };

      lspBuf = {
        "gd" = "definition";
        "gr" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };
      silent = true;
    };
  };
}
