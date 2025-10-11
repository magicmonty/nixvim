{
  plugins.illuminate = {
    enable = true;
    settings = {
      delay = 200;
      largeFileCutoff = 2000;
      largeFileOverrides = {
        providers = ["lsp"];
      };
    };
  };
}
