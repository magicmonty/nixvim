{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.tailwindcss = {
    enable = mkEnableOption "Tailwind CSS support";
  };

  config = let
    inherit (config.sys.lang.tailwindcss) enable;
  in
    mkIf enable {
      plugins = {
        lsp.enable = true;
      };

      lsp = {
        servers = {
          tailwindcss = {
            enable = true;
            config = {
              filetypes = ["javascript" "javascriptreact" "typescript" "typescriptreact" "html" "css" "scss" "vue" "svelte" "htmlangular"];
            };
          };
        };
      };
    };
}
