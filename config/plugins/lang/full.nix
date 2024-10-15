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
    ./neorg
  ];

  config.sys.lang.neorg.enable = mkDefault false;
  config.sys.lang.obsidian.enable = mkDefault true;
}
