{lib, ...}:
with lib; {
  imports = [
    ./angular
    ./json
    ./markdown
    ./neorg
    ./obsidian
    ./powershell
    ./tailwindcss
  ];

  config.sys.lang.neorg.enable = mkDefault false;
  config.sys.lang.obsidian.enable = mkDefault false;
}
