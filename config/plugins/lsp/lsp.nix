{pkgs, ...}: {
  plugins.lsp.enable = true;
  lsp = {
    onAttach =
      # lua
      ''
        vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "LSP info", silent = true })
        vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References", silent = true })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
        vim.keymap.set("n", "gi", function() require('telescope.builtin').lsp_implementations({ reuse_win = true }) end, { desc = "Goto Implementation" })
        vim.keymap.set("n", "gt", function() require('telescope.builtin').lsp_type_definitions({ reuse_win = true }) end, { desc = "Goto Type Definition" })
        vim.keymap.set("n", "<leader>cr", function()
          local inc_rename = require("inc_rename")
          return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
        end, {desc = "Rename"})

        if NixVim.lsp.has(bufnr, "definition") then
          vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions({ reuse_win = true }) end, { desc = "Goto Definition", buffer = 0 })
        end

        if NixVim.lsp.has(bufnr, "hover") then
          vim.keymap.set("n", "K", vim.lsp.buf.hover)
        end

        if NixVim.lsp.has(bufnr, "signatureHelp") then
          vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
          vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
        end

        if NixVim.lsp.has(bufnr, "codeAction") then
          vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", buffer = 0 })
          vim.keymap.set("n", "<leader>cA", function()
            vim.lsp.buf.code_action({
              context = {
                only = { "source" },
                diagnostics = {},
              },
            })
          end, { desc = "Source Action", buffer = 0 })
        end

        if NixVim.lsp.has(bufnr, "codeLens") then
          vim.keymap.set({"n", "v"}, "<leader>cc", vim.lsp.codelens.run, { desc = "Run Codelens" })
          vim.keymap.set("n", "<leader>cC", vim.lsp.codelens.refresh, { desc = "Refresh & Display Codelens" })
        end

      '';

    servers = {
      angularls = {
        enable = true;
        config = {
          root_markers = ["angular.json" "nx.json" "project.json"];
        };
      };
      bashls.enable = true;
      clangd.enable = true;
      gopls.enable = true;
      lemminx.enable = true;
      tinymist.enable = true;
      ts_ls = {
        enable = true;
        config.onAttach.function =
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
        config = {
          completions.completeFunctionCalls = true;
        };
      };
      lua_ls = {
        enable = true;
        config.telemetry.enable = false;
      };
      eslint = {
        enable = true;
        config = {
          workingDirectories = {mode = "auto";};
        };
      };
      nixd = {
        enable = true;

        config = {
          # nixpkgs.expr = "import <nixpkgs> { }";
          # formatting.command = ["alejandra"];
          options = {
            nixvim.expr = ''(builtins.getFlake "github:magicmonty/nixvim").packages.${pkgs.system}.neovimNixvim.options'';
          };
        };
      };
      nil_ls.enable = false;
      dockerls.enable = true;
      docker_compose_language_service.enable = true;
      marksman.enable = true;
      tailwindcss = {
        enable = true;
        config = {
          filetypes = ["javascript" "javascriptreact" "typescript" "typescriptreact" "html" "css" "scss" "vue" "svelte"];
        };
      };
      texlab = {
        enable = true;
        config.onAttach.function =
          # lua
          ''
            vim.keymap.set("n", "<leader>K", "<plug>(vimtex-doc-package)",{desc = "Vimtex docs", silent = true})
          '';
      };
      jsonls.enable = true;
      yamlls = {
        enable = true;
        config = {
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
        config = {
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
  };
  extraConfigLua =
    # lua
    ''
      local _border = "rounded"

      vim.diagnostic.config {
        float = { border = _border },
      }

      local _signs = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
      }

      for severity, icon in pairs(_signs) do
        local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
    '';
}
