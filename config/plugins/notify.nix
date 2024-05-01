{
  plugins.notify = {
    enable = true;
    stages = "static";
    timeout = 3000;
    maxHeight = {
      __raw =
        # lua
        ''
          function()
            math.floor(vim.o.lines * 0.75)
          end
        '';
    };
    maxWidth = {
      __raw =
        # lua
        ''
          function()
            math.floor(vim.o.columns * 0.75)
          end
        '';
    };
    onOpen =
      # lua
      ''
        function(win)
          vim.api.nvim_win_set_config(win, { zindex = 100 })
        end
      '';
  };

  keymaps = [
    {
      key = "<leader>un";
      action =
        # lua
        ''
          function()
            require("notify").dismiss({ silent = true, pending = true })
          end
        '';
      options = {
        desc = "Dismiss all notifications";
      };
    }
  ];
}
