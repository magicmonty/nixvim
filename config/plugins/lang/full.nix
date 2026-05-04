{
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
    ./clojure
    ./dotnet
    ./json
    ./markdown
    ./neorg
    ./obsidian
    ./rust
    ./sql
    ./swift
    ./tailwindcss
    ./tex
    ./typst
    ./vue
  ];

  config.sys.lang = {
    clojure.enable = mkDefault true;
    neorg.enable = mkDefault false;
    obsidian.enable = mkDefault true;
    vue.enable = mkDefault true;
    dotnet.enable = mkDefault true;
    sql.enable = mkDefault true;
    rust.enable = mkDefault true;
    swift.enable = mkDefault (pkgs.stdenv.hostPlatform.system == "aarch64-darwin");
    tex.enable = mkDefault true;
  };
}
