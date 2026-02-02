{config, ...}: {
  plugins.lsp.enable = true;
  lsp = {
    servers = {
      marksman.enable = config.sys.lang.dotnet.enable;
    };
  };
}
