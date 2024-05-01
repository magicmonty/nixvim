{
  plugins.neo-tree = {
    enable = true;
    closeIfLastWindow = true;
  };

  keymaps = [
    {
      key = "<leader>.";
      action = "<cmd>Neotree toggle<CR>";
    }
  ];
}
