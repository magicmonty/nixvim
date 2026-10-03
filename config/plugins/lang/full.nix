{
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./angular
    ./clojure
    ./dotnet
    ./go
    ./json
    ./lua
    ./markdown
    ./neorg
    ./obsidian
    ./php
    ./python
    ./qml
    ./rust
    ./sql
    ./swift
    ./tailwindcss
    ./tex
    ./typst
    ./vue
    ./web
    ./yaml
  ];

  config.sys.lang = {
    angular.enable = mkDefault true;
    clojure.enable = mkDefault true;
    dotnet.enable = mkDefault true;
    go.enable = mkDefault true;
    json.enable = mkDefault true;
    lua.enable = mkDefault true;
    markdown = {
      enable = mkDefault true;
      lsp.enable = mkDefault true;
      preview.enable = mkDefault true;
    };
    neorg.enable = mkDefault false;
    obsidian.enable = mkDefault true;
    python.enable = mkDefault true;
    php.enable = mkDefault true;
    qml.enable = mkDefault true;
    rust.enable = mkDefault true;
    sql.enable = mkDefault true;
    swift.enable = mkDefault (pkgs.stdenv.hostPlatform.system == "aarch64-darwin");
    tailwindcss.enable = mkDefault true;
    tex.enable = mkDefault (pkgs.stdenv.hostPlatform.system != "aarch64-darwin");
    typst.enable = mkDefault true;
    vue.enable = mkDefault true;
    web.enable = mkDefault true;
    yaml.enable = mkDefault true;
  };
}
