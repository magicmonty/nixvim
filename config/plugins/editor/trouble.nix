{
  plugins.trouble = {
    enable = true;
    settings = {
      auto_close = true;
      auto_jump = true;
    };
  };

  keymaps = [
    {
      key = "<leader>xx";
      action = "<cmd>TroubleToggle document_diagnostics<cr>";
      options = {
        desc = "Document diagnostics (Trouble)";
      };
    }
    {
      key = "<leader>xX";
      action = "<cmd>TroubleToggle workspace_diagnostics<cr>";
      options = {
        desc = "Workspace diagnostics (Trouble)";
      };
    }
    {
      key = "<leader>xL";
      action = "<cmd>TroubleToggle loclist<cr>";
      options = {
        desc = "Location List (Trouble)";
      };
    }
    {
      key = "<leader>xQ";
      action = "<cmd>TroubleToggle quickfix<cr>";
      options = {
        desc = "Quickfix List (Trouble)";
      };
    }
    {
      key = "öq";
      action = {
        __raw =
          # lua
          ''
            function()
              if require("trouble").is_open() then
                require("trouble").previous({ skip_groups = true, jump = true })
              else
                local ok, err = pcall(vim.cmd.cprev)
                if not ok then
                  vim.notify(err, vim.log.levels.ERROR)
                end
              end
            end
          '';
      };
      options = {
        desc = "Previous Trouble/Quickfix Item";
      };
    }
    {
      key = "äq";
      action = {
        __raw =
          # lua
          ''
            function()
              if require("trouble").is_open() then
                require("trouble").next({ skip_groups = true, jump = true })
              else
                local ok, err = pcall(vim.cmd.cnext)
                if not ok then
                  vim.notify(err, vim.log.levels.ERROR)
                end
              end
            end
          '';
      };
      options = {
        desc = "Next Trouble/Quickfix Item";
      };
    }
  ];
}
