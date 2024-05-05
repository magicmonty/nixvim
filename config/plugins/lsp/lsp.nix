{
  plugins.lsp = {
    enable = true;

    servers = {
      bashls.enable = true;
      clangd.enable = true;
      tsserver.enable = true;
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
