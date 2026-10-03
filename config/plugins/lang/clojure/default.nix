{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.clojure = {
    enable = mkEnableOption "clojure support";
  };

  config = let
    inherit (config.sys.lang.clojure) enable;
  in
    mkIf enable {
      plugins = {
        lsp.enable = true;
        lz-n.enable = true;

        conjure = {
          enable = true;
          lazyLoad = {
            enable = true;
            settings.ft = "clojure";
          };
        };

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          clojure
        ];
      };

      lsp.servers.clojure_lsp.enable = true;
    };
}
