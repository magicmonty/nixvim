{lib, ...}:
with lib; {
  imports = [
    ./angular
    ./json
    ./markdown
    ./neorg
    ./obsidian
    ./powershell
    ./rust
    ./tailwindcss
    ./tex
    ./vue
  ];

  config.sys.lang = {
    neorg.enable = mkDefault false;
    obsidian.enable = mkDefault true;
    vue.enable = mkDefault true;
  };
}
