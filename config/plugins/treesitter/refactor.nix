{
  plugins.treesitter-refactor = {
    enable = true;
    highlightCurrentScope.enable = false;
    highlightDefinitions.enable = true;
    navigation = {
      enable = true;
      keymaps = {
        gotoDefinition = "gd";
      };
    };
    smartRename = {
      enable = true;
      keymaps.smartRename = "<leader>rr";
    };
  };
}
