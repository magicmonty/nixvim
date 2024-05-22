{
  # Import all your configuration modules here
  imports = [
    ./plugins/lite.nix
    ./icons_lua.nix
    ./autocmds.nix
    ./opts.nix
    ./keymaps.nix
    ./utils
  ];

  config = {
    nixvim.flavour = "lite";
  };
}
