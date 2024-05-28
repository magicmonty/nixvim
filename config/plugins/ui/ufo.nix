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
      action.__raw = "require('ufo').openAllFolds";
      options = {
        desc = "Open all folds";
      };
    }
    {
      mode = "n";
      key = "zM";
      action.__raw = "require('ufo').closeAllFolds";
      options = {
        desc = "Open all folds";
      };
    }
  ];
}
