{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.typst = {
    enable = mkEnableOption "typst support";
  };

  config = let
    inherit (config.sys.lang.typst) enable;
  in
    mkIf enable {
      dependencies = {
        typst.enable = true;
        tinymist.enable = true;
        websocat.enable = true;
      };

      plugins = {
        lsp.enable = true;

        treesitter = {
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            typst
          ];
        };

        typst-preview.enable = true;
        typst-vim.enable = true;
      };

      lsp.servers.tinymist = {
        enable = true;
        config = {
          settings = {
            exportPdf = "onType"; # "auto" | "never" | "onSave" | "onType"
            formatterMode = "typstyle"; # "disabled" | "typstyle" | "typsfmt"
          };
        };
      };
    };
}
