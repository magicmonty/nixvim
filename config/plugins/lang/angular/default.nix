{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.angular = {
    enable = mkEnableOption "angular support";
  };

  config = let
    inherit (config.sys.lang.angular) enable;
  in
    mkIf enable {
      sys.lang.web.enable = mkForce true;
      sys.lang.tailwindcss.enable = mkForce true;

      plugins = {
        lsp.enable = true;

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          angular
        ];

        conform-nvim.settings.formatters_by_ft = {
          htmlangular = ["oxfmt" "oxlint" "prettierd" "prettier"];
        };
      };

      lsp.servers.angularls = {
        enable = true;

        config = {
          root_markers = ["angular.json" "nx.json" "project.json"];
        };
      };
    };
}
