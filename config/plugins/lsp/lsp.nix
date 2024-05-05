{
  plugins.lsp = {
    enable = true;
    onAttach =
      # lua
      ''
        vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "LSP info", silent = true })
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References", silent = true })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
        vim.keymap.set("n", "gI", function() require('telescope.builtin').lsp_implementations({ reuse_win = true }) end, { desc = "Goto Implementation" })
        vim.keymap.set("n", "gy", function() require('telescope.builtin').lsp_type_definitions({ reuse_win = true }) end, { desc = "Goto T[y]pe Definition" })
        vim.keymap.set("n", "<leader>cr", function()
          local inc_rename = require("inc_rename")
          return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end, {desc = "Rename"})

        if NixVim.lsp.has(bufnr, "definition") then
          vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions({ reuse_win = true }) end, { desc = "Goto Definition" })
        end

        if NixVim.lsp.has(bufnr, "signatureHelp") then
          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
        end

        if NixVim.lsp.has(bufnr, "codeAction") then
          vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
          vim.keymap.set("n", "<leader>cA", function()
            vim.lsp.buf.code_action({
              context = {
                only = { "source" },
                diagnostics = {},
              },
            })
          end, { desc = "Source Action" })
        end

        if NixVim.lsp.has(bufnr, "codeLens") then
          vim.keymap.set({"n", "v"}, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
          vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
        end

      '';

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
              { desc = "Organize imports" }
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
              { desc = "Remove unused imports" }
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
            vim.keymap.set("n", "<leader>K", "<plug>(vimtex-doc-package)",{desc = "Vimtex docs", silent = true})
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
        "gt" = "type_definition";
        "gi" = "implementation";
        "K" = "hover";
      };
      silent = true;
    };
  };
}
