{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.python = {
    enable = mkEnableOption "Python support";
  };

  config = let
    inherit (config.sys.lang.python) enable;
  in
    mkIf enable {
      plugins = {
        lsp.enable = true;

        jupytext = {
          enable = true;
        };

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          pymanifest
          python
        ];

        conform-nvim.settings.formatters_by_ft = {
          python = ["ruff_format" "ruff_fix" "ruff_organize_imports"];
        };

        neotest.adapters = {
          python = {
            enable = true;
          };
        };

        dap-python.enable = true;
      };

      lsp.servers = {
        pyrefly.enable = true;
        ruff.enable = true;
      };
    };
}
