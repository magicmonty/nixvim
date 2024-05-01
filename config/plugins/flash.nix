{
  plugins.flash = {
    enable = true;
    extraOptions = {
      vscode = true;
    };
  };
  /*
  keymaps = [
    {
      mode = ["n" "x" "o"];
      key = "s";
      lua = true;
      action =
        # lua
        ''
          function()
            require("flash").jump()
          end
        '';
    }
    {
      mode = ["n" "x" "o"];
      key = "S";
      lua = true;
      action =
        # lua
        ''
          function()
            require("flash").treesitter()
          end
        '';
    }
    {
      mode = ["o"];
      key = "r";
      lua = true;
      action =
        # lua
        ''
          function()
            require("flash").remote()
          end
        '';
    }
    {
      mode = ["o" "x"];
      key = "R";
      lua = true;
      action =
        # lua
        ''
          function()
            require("flash").treesitter_search()
          end
        '';
    }
    {
      mode = ["c"];
      key = "<C-s>";
      lua = true;
      action =
        # lua
        ''
          function()
            require("flash").toggle()
          end
        '';
    }
  ];
  */
}
