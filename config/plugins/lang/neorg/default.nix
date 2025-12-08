{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.neorg.enable = mkEnableOption "Neorg support";

  config = let
    inherit (config.sys.lang.neorg) enable;
  in
    mkIf enable {
      plugins = {
        neorg = {
          enable = true;
          settings = {
            modules = {
              "core.concealer" = {
                folds = false;
              };
            };
          };
        };
      };

      # Workaround for missing lua-utils
      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          inherit (pkgs.luaPackages.lua-utils-nvim) pname version src;
        })

        (pkgs.vimUtils.buildVimPlugin {
          inherit (pkgs.luaPackages.pathlib-nvim) pname version src;
        })

        (pkgs.vimUtils.buildVimPlugin {
          inherit (pkgs.luaPackages.nvim-nio) pname version src;
        })
      ];
    };
}
