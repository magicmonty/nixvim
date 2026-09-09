_: {
  plugins.lsp.enable = true;
  lsp = {
    servers = {
      texlab = {
        enable = true;
        config = {
          settings = {
            on_attach.__raw =
              # lua
              ''
                function(client, bufnr)
                  vim.keymap.set("n", "<leader>K", "<plug>(vimtex-doc-package)",{desc = "Vimtex docs", silent = true})
                end
              '';
          };
        };
      };
    };
  };
}
