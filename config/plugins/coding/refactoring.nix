{
  plugins = {
    refactoring = {
      enable = true;
      enableTelescope = true;
    };

    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>r";
        group = "Refactoring";
        icon = "";
      }
      {
        __unkeyed-1 = "<leader>rd";
        group = "Debug";
        icon = "";
      }
    ];
  };

  keymaps = [
    {
      mode = "x";
      key = "<leader>re";
      action = "<cmd>Refactor extract ";
      options = {
        desc = "Extract";
      };
    }
    {
      mode = "x";
      key = "<leader>rf";
      action = "<cmd>Refactor extract_to_file ";
      options = {
        desc = "Extract to file";
      };
    }
    {
      mode = "x";
      key = "<leader>rv";
      action = "<cmd>Refactor extract_var ";
      options = {
        desc = "Extract Variable";
      };
    }
    {
      mode = ["n" "x"];
      key = "<leader>ri";
      action = "<cmd>Refactor inline_var<cr>";
      options = {
        desc = "Inline Variable";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>rI";
      action = "<cmd>Refactor inline_func<cr>";
      options = {
        desc = "Inline Function";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>rdp";
      action.__raw = "function() require('refactoring').debug.printf({ below = false }) end";
      options = {desc = "Print Position";};
    }
    {
      mode = ["x" "n"];
      key = "<leader>rdv";
      action.__raw = "function() require('refactoring').debug.print_var() end";
      options = {desc = "Print Variable";};
    }
    {
      mode = "n";
      key = "<leader>rdc";
      action.__raw = "function() require('refactoring').debug.cleanup({}) end";
      options = {desc = "Cleanup";};
    }
  ];
}
