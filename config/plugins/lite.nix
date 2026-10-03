{lib, ...}:
with lib; {
  imports = [
    ./ai/lite.nix
    ./coding/lite.nix
    ./colorscheme
    ./custom
    ./editor
    ./formatting
    ./lang/lite.nix
    ./linting
    ./lsp
    ./treesitter
    ./ui
  ];

  config = {
    sys.ai.enable = mkDefault false;
    lsp.servers.texlab.enable = mkForce false;
  };
}
