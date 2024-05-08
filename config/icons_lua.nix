{helpers, ...}: let
  icons = import ./icons.nix {};
  icons_lua = helpers.toLuaObject icons;
in {
  extraConfigLuaPre = "icons = ${icons_lua}";
}
