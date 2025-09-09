{lib, ...}:
with lib; {
  imports = [
    ./dotnet
    ./json
    ./markdown
    ./neorg
    ./obsidian
    ./powershell
    ./rust
    ./sql
    #    ./tailwindcss
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
  };
}
