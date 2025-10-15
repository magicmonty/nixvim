{lib, ...}: {
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
    lsp.servers.texlab.enable = lib.mkForce false;
  };
}
