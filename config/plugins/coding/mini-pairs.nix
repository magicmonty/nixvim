{
  plugins.mini.modules.pairs = {
    mappings = {
      "`" = {
        action = "closeopen";
        pair = "``";
        neigh_pattern = "[^\\`].";
        register = {cr = false;};
      };
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>up";
      action.__raw =
        # lua
        ''
          function()
            vim.g.minipairs_disable = not vim.g.minipairs_disable
            if vim.g.minipairs_disable then
              NixVim.warn("Disabled auto pairs", { title = "Option" })
            else
              NixVim.info("Enabled auto pairs", { title = "Option" })
            end
          end
        '';
      options = {
        desc = "Toggle Auto Pairs";
      };
    }
  ];
}
