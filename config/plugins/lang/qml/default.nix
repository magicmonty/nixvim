{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.qml = {
    enable = mkEnableOption "QML support";
  };

  config = let
    inherit (config.sys.lang.qml) enable;
  in
    mkIf enable {
      plugins = {
        lsp.enable = true;

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          qmldir
          qmljs
        ];
      };

      lsp.servers.qmlls.enable = true;
    };
}
