_: {
  config = {
    dependencies = {
      typst.enable = true;
      tinymist.enable = true;
      websocat.enable = true;
    };
    lsp.servers.tinymist.enable = true;
    plugins = {
      typst-preview.enable = true;
      typst-vim.enable = true;
      lsp.servers.tinymist = {
        enable = true;
        settings = {
          exportPdf = "onType"; # "auto" | "never" | "onSave" | "onType"
          formatterMode = "typstyle"; # "disabled" | "typstyle" | "typsfmt"
        };
      };
    };
  };
}
