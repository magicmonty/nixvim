{
  plugins.flash = {
    enable = true;
    extraOptions = {
      vscode = true;
    };
  };
  keymaps = [
    {
      mode = ["n" "x" "o"];
      key = "s";
      action.__raw =
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
      action.__raw =
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
      action.__raw =
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
      action.__raw =
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
      action.__raw =
        # lua
        ''
          function()
            require("flash").toggle()
          end
        '';
    }
  ];
}
