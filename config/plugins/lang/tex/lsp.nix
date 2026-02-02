_: {
  plugins.lsp.enable = true;
  lsp = {
    servers = {
      texlab = {
        enable = true;
        config.onAttach.function =
          # lua
          ''
            vim.keymap.set("n", "<leader>K", "<plug>(vimtex-doc-package)",{desc = "Vimtex docs", silent = true})
          '';
      };
    };
  };
}
