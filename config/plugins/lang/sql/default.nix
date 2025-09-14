{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.sql = {
    enable = mkEnableOption "Database support";
  };

  config = let
    inherit (config.sys.lang.sql) enable;
  in
    mkIf enable {
      plugins = {
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
