{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.go = {
    enable = mkEnableOption "go support";
  };

  config = let
    inherit (config.sys.lang.go) enable;
  in
    mkIf enable {
      plugins = {
        lsp.enable = true;

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          go
          gomod
          gosum
          gotmpl
          gowork
        ];

        conform-nvim.settings.formatters_by_ft.go = ["gofmt"];
      };

      lsp.servers.gopls.enable = true;
    };
}
