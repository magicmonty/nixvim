{lib, ...}:
with lib; {
  imports = [
    ./json
    ./markdown
    ./neorg
    ./obsidian
    ./powershell
    ./rust
    ./tailwindcss
    ./tex
    ./typst
    ./vue
  ];

  config.sys.lang = {
    neorg.enable = mkDefault false;
    obsidian.enable = mkDefault true;
    vue.enable = mkDefault true;
  };
}
