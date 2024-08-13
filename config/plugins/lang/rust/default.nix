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
      action.__raw =
        #lua
        ''
          function()
            require("neotest").run.run_last()
          end
        '';
      options = {desc = "Run latest tests";};
    }
    {
      mode = "n";
      key = "<leader>cts";
      action.__raw =
        #lua
        ''
          function()
            require("neotest").summary.toggle()
          end
        '';
      options = {desc = "Neotest: Toggle summary pane";};
    }
  ];

  extraConfigLuaPost =
    #lua
    ''
      require('neotest').setup({
          adapters = {
              require('rustaceanvim.neotest')
          }
      })
    '';
}
