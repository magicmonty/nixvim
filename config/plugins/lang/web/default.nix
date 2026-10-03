{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.web = {
    enable = mkEnableOption "web languages (HTML/CSS/Typescript/Javascript) support";
  };

  config = let
    inherit (config.sys.lang.web) enable;
  in
    mkIf enable {
      plugins = {
        lsp.enable = true;

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          typescript
          javascript
          jsdoc
        ];

        conform-nvim.settings.formatters_by_ft = {
          html = ["oxfmt" "oxlint" "prettierd" "prettier"];
          css = ["oxfmt" "oxlint" "prettierd" "prettier"];
          javascript = ["oxfmt" "oxlint" "prettierd" "prettier"];
          javascriptreact = ["oxfmt" "oxlint" "prettierd" "prettier"];
          typescript = ["oxfmt" "oxlint" "prettierd" "prettier"];
          typescriptreact = ["oxfmt" "oxlint" "prettierd" "prettier"];
        };
      };

      lsp.servers = {
        vtsls = {
          enable = true;
          config = {
            filetypes = ["typescript" "javascript" "javascript.jsx" "typescript.tsx" "javascriptreact" "typescriptreact" "htmlangular" "vue"];
            capabilities = {
              textDocument = {
                documentHighlight = false;
              };
            };
            on_attach.__raw =
              # lua
              ''
                function(client, bufnr)
                  client.server_capabilities.documentHighlightProvider = false;
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
                end
              '';
            settings = {
              vtsls = {
                enableMoveToFileCodeAction = true;
                autoUseWorkspaceTsdk = true;
                experimental.completion = {
                  enableServerSideFuzzyMatch = true;
                  entriesLimit = 20;
                };
              };
              typescript = {
                updateImportsOnFileMove = "always";
                inlayHints = {
                  parameterNames.enabled = "literals";
                  parameterTypes.enabled = true;
                  variableTypes.enabled = true;
                  propertyDeclarationTypes.enabled = true;
                  functionLikeReturnTypes.enabled = true;
                  enumMemberValues.enabled = true;
                };
              };
              javascript = {
                updateImportsOnFileMove = "always";
              };
            };
            config = {
              completions.completeFunctionCalls = true;
            };
          };
        };

        oxlint.enable = true;

        eslint = {
          enable = true;
          config = {
            settings = {
              workingDirectories = [{mode = "auto";}];
              onIgnoredFiles = "off";
              experimental.useFlatConfig = true;
              execArgv = ["--no-warn-ignored"];
            };
          };
        };
      };
    };
}
