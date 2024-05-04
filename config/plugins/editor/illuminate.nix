{
  plugins.illuminate = {
    enable = true;
    delay = 200;
    largeFileCutoff = 2000;
    largeFileOverrides = {
      providers = ["lsp"];
    };
  };
}
