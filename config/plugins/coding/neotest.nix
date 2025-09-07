{
  config,
  lib,
  ...
}:
with lib; {
  plugins = {
    neotest.enable = true;
  };

  keymaps = mkIf config.plugins.neotest.enable [
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
      key = "<leader>ctd";
      action.__raw =
        #lua
        ''
          function()
            require("neotest").run.run({ strategy = "dap" })
          end
        '';
      options = {desc = "Debug nearest test";};
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
}
