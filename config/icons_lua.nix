{lib, ...}: let
  icons = import ./icons.nix {};
  icons_lua = lib.nixvim.toLuaObject icons;
in {
  extraConfigLuaPre = "icons = ${icons_lua}";
}
