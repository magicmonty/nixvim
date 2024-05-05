{
  plugins.vimtex = {
    enable = true;
  };

  globals = {
    # disable `K` as it conflicts with LSP hover
    vimtext_mappings_disable = {n = ["K"];};

    vimtex_quickfix_method = {__raw = "vim.fn.executable('pplatex') == 1 and 'pplatex' or 'latexlog'";};
  };
}
