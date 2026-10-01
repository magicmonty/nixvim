{
  config,
  lib,
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
      lsp.servers = {
        pyrefly = {
          enable = true;
        };
      };

      plugins = {
        jupytext = {
          enable = true;
        };
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
    };
}
