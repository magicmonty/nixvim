_: {
  plugins = {
    neotest.enable = true;
    rustaceanvim = {
      enable = true;
      settings = {
        server = {
          default_settings = {
            rust-analyzer = {
              check.command = "clippy";
              inlayHints = {
                lifetimeElisionHints = {
                  enable = "always";
                };
              };
            };
          };
        };
        standalone = false;
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ctf";
      action.__raw =
        #lua
        ''
          function()
            require("neotest").run.run(vim.fn.expand("%"))
            end
        '';
      options = {desc = "Run all tests in file";};
    }
    {
      mode = "n";
      key = "<leader>ctr";
      action.__raw =
        #lua
        ''
          function()
            require("neotest").run.run()
            end
        '';
      options = {desc = "Run nearest test";};
    }
    {
      mode = "n";
      key = "<leader>ctw";
      action.__raw =
        #lua
        ''
          function()
            require("neotest").watch.toggle()
            end
        '';
      options = {desc = "Toggle test watcher";};
    }
    {
      mode = "n";
      key = "<leader>ctt";
      action = "<cmd>Neotest run latest<cr>";
      options = {desc = "Run latest tests";};
    }
  ];

  extraConfigLua =
    #lua
    ''
      require("neotest").setup({
        adapters = {
          rust = require("rustaceanvim.neotest")
        }
      })
    '';
}
