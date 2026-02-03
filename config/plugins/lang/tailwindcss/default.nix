{
  config,
  lib,
  ...
}: {
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
}
