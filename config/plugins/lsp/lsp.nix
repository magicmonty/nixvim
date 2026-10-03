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
        end, {desc = "Rename", expr = true})

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
      bashls.enable = true;
      clangd.enable = true;
      lemminx.enable = true;
      nixd = {
        enable = true;

        config = {
          # nixpkgs.expr = "import <nixpkgs> { }";
          # formatting.command = ["alejandra"];
          options = {
            nixvim.expr = ''(builtins.getFlake "github:magicmonty/nixvim").packages.${pkgs.stdenv.hostPlatform.system}.neovimNixvim.options'';
          };
        };
      };
      nil_ls.enable = true;
      dockerls.enable = true;
      docker_compose_language_service.enable = true;
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
