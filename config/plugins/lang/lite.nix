{lib, ...}:
with lib; {
  imports = [
    ./angular
    ./json
    ./markdown
    ./neorg
    ./powershell
    ./tailwindcss
  ];

  config.sys.lang.neorg.enable = mkDefault false;
}
