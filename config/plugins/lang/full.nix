{
  lib,
  pkgs,
  ...
}:
with lib; {
  imports = [
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
    neorg.enable = mkDefault false;
    obsidian.enable = mkDefault true;
    vue.enable = mkDefault true;
    dotnet.enable = mkDefault true;
    sql.enable = mkDefault true;
    rust.enable = mkDefault true;
    swift.enable = mkDefault (pkgs.stdenv.hostPlatform.system == "aarch64-darwin");
  };
}
