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
