{pkgs, ...}: {
  extraConfigLua =
    # lsp
    ''
      local __angularCapabilities = function()
        capabilities = vim.lsp.protocol.make_client_capabilities()

        --  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        return capabilities
      end

      local __angularGenCmd = function(root_dir)
        return {
          "${pkgs.angular-language-server}/bin/angular-language-server",
          "--stdio",
          "--tsProbeLocations",
          root_dir or "",
          "--ngProbeLocations",
          root_dir or "",
        }
      end

      local __lsp = require("lspconfig")

      __lsp.angularls.setup({
        cmd = __angularGenCmd(""),
        on_new_config = function(new_config, new_root_dir)
          new_config.cmd = __angularGenCmd(new_root_dir)
        end,
        root_dir = __lsp.util.root_pattern("angular.json", "project.json", "package.json", ".git"),
        on_attach = __lspOnAttach,
        capabilities = __angularCapabilities()
      })
    '';
}
