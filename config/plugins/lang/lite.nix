{lib, ...}:
with lib; {
  imports = [
    ./dotnet
    ./json
    ./lua
    ./markdown
    ./yaml
  ];
  config.sys.lang = {
    dotnet.enable = mkDefault false;
    json.enable = mkDefault true;
    lua.enable = mkDefault true;
    markdown = {
      enable = mkDefault true;
      lsp.enable = mkDefault false;
      preview.enable = mkDefault false;
    };
    yaml.enable = mkDefault true;
  };
}
