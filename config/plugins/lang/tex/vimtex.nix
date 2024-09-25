{pkgs, ...}: {
  plugins.vimtex = {
    enable = true;
    texlivePackage = null;
    settings = {
      view_method = "zathura";
    };
  };

  globals = {
    # disable `K` as it conflicts with LSP hover
    vimtext_mappings_disable = {n = ["K"];};

    vimtex_quickfix_method = {__raw = "vim.fn.executable('pplatex') == 1 and 'pplatex' or 'latexlog'";};
  };

  extraPackages = with pkgs; [
    zathura
    python312Packages.pygments
  ];
}
