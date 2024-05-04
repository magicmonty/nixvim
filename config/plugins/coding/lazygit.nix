{
  plugins.lazygit = {
    enable = true;
  };

  keymaps = [
    {
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      options = {
        desc = "LazyGit";
      };
    }
  ];
}
