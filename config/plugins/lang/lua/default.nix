{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.lua = {
    enable = mkEnableOption "Lua support";
  };

  config = let
    inherit (config.sys.lang.lua) enable;
  in
    mkIf enable {
      extraPackages = with pkgs; [
        stylua
      ];

      plugins = {
        lsp.enable = true;

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          lua
          luadoc
          luap
          luau
        ];

        conform-nvim.settings = {
          formatters = {
            stylua = {
              command = lib.getExe pkgs.stylua;
            };
          };

          formatters_by_ft = {
            lua = ["stylua"];
          };
        };
      };

      lsp.servers.lua_ls = {
        enable = true;
        config.telemetry.enable = false;
      };
    };
}
