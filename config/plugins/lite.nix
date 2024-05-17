{lib, ...}: {
  imports = [
    ./coding/lite.nix
    ./colorscheme
    ./editor
    ./formatting
    ./lang/lite.nix
    ./linting
    ./lsp
    ./treesitter
    ./ui
  ];

  config = {
    plugins.lsp.servers.texlab.enable = lib.mkForce false;
  };
}
