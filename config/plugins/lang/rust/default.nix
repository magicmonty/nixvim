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
      key = "<leader>ur";
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
      key = "<leader>ut";
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
      key = "<leader>uw";
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
      key = "<leader>uu";
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
