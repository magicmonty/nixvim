{
  plugins.nvim-ufo = {
    enable = true;
  };

  opts = {
    foldcolumn = "0";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "zR";
      action = "require('ufo').openAllFolds";
      lua = true;
      options = {
        desc = "Open all folds";
      };
    }
    {
      mode = "n";
      key = "zM";
      action = "require('ufo').closeAllFolds";
      lua = true;
      options = {
        desc = "Open all folds";
      };
    }
  ];
}
