{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.sql = {
    enable = mkEnableOption "Database support";
    customFormatter = mkEnableOption "Enables the custom sqlfluff configuration";
  };

  config = let
    inherit (config.sys.lang.sql) enable customFormatter;
  in
    mkIf enable {
      extraPackages = with pkgs; [
        # sqlfluff
        sqruff
      ];

      plugins = {
        lsp.enable = true;

        conform-nvim.settings = {
          formatters = {
            sqlfluff = let
              config = ./sqlfluff.toml;
            in
              mkIf customFormatter {
                command = lib.getExe pkgs.sqlfluff;
                args = [
                  "fix"
                  "--config"
                  "${config}"
                  "-"
                ];
                require_cwd = false;
              };
          };
          formatters_by_ft.sql = ["sqlfluff"];
        };

        vim-dadbod.enable = true;
        vim-dadbod-completion.enable = true;
        vim-dadbod-ui.enable = true;
        lsp.servers = {
          sqls = {
            enable = true;
            filetypes = ["sql"];
          };
        };
        blink-cmp.settings.sources = {
          providers.dadbod = {
            module = "vim_dadbod_completion.blink";
            name = "dadbod";
          };
          per_filetype.sql = ["snippets" "dadbod" "buffer"];
        };
      };
    };
}
