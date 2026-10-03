{lib, ...}:
with lib; {
  imports = [
    ./ai
    ./coding
    ./colorscheme
    ./editor
    ./formatting
    ./lang
    ./linting
    ./lsp
    ./treesitter
    ./ui
    ./custom
  ];

  config = {
    sys.ai.enable = mkDefault true;
  };
}
