{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.json = {
    enable = mkEnableOption "JSON support";
  };
  config = let
    inherit (config.sys.lang.json) enable;
  in
    mkIf enable {
      plugins = {
        lsp.enable = true;
        schemastore.enable = true;

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          json
          json5
          jsonnet
        ];

        conform-nvim.settings.formatters_by_ft = {
          json = ["oxfmt" "oxlint" "prettierd" "prettier"];
        };
      };
      lsp.servers = {
        oxlint.enable = true;
        jsonls.enable = true;
      };
    };
}
