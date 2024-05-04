{
  plugins.noice = {
    enable = true;
    messages.enabled = true;
    lsp = {
      message.enabled = true;
      progress = {
        enabled = false;
        view = "mini";
      };
      override = {
        "vim.lsp.util.convert_input_to_markdown_lines" = true;
        "vim.lsp.util.stylize_markdown" = true;
        "cmp.entry.get_documentation" = true;
      };
    };
    popupmenu = {
      enabled = true;
      backend = "nui";
    };
    format = {
      filter = {
        pattern = [":%s*%%s*s:%s*" ":%s*%%s*s!%s*" ":%s*%%s*s/%s*" "%s*s:%s*" ":%s*s!%s*" ":%s*s/%s*"];
        icon = "";
        lang = "regex";
      };
      replace = {
        pattern = [":%s*%%s*s:%w*:%s*" ":%s*%%s*s!%w*!%s*" ":%s*%%s*s/%w*/%s*" "%s*s:%w*:%s*" ":%s*s!%w*!%s*" ":%s*s/%w*/%s*"];
        icon = "󱞪";
        lang = "regex";
      };
    };
    routes = [
      {
        filter = {
          event = "msg_show";
          any = [
            {find = "%d+L, %d+B";}
            {find = "; after #%d+";}
            {find = "; before #%d+";}
          ];
        };
        view = "mini";
      }
    ];
    presets = {
      bottom_search = true;
      command_palette = true;
      long_message_to_split = true;
      inc_rename = true;
    };
  };

  keymaps = [
    {
      mode = ["c"];
      key = "<S-Enter>";
      action = "function() require('noice').redirect(vim.fn.getcmdline()) end";
      lua = true;
      options = {desc = "Redirect Cmdline";};
    }
    {
      key = "<leader>snl";
      action = "function() require('noice').cmd('last') end";
      options = {desc = "Noice Last Message";};
    }
    {
      key = "<leader>snh";
      action = "function() require('noice').cmd('history') end";
      options = {desc = "Noice History";};
    }
    {
      key = "<leader>sna";
      action = "function() require('noice').cmd('all') end";
      options = {desc = "Noice All";};
    }
    {
      key = "<leader>snd";
      action = "function() require('noice').cmd('dismiss') end";
      options = {desc = "Dismiss All";};
    }
    {
      mode = ["i" "n" "s"];
      key = "<c-f>";
      action =
        # lua
        ''
          function()
            if not require('noice.lsp').scroll(4) then
              return '<c-f>'
            end
          end
        '';
      lua = true;
      options = {
        silent = true;
        expr = true;
        desc = "Scroll Forward";
      };
    }
    {
      mode = ["i" "n" "s"];
      key = "<c-d>";
      action =
        # lua
        ''
          function()
            if not require('noice.lsp').scroll(-4) then
              return '<c-b>'
            end
          end
        '';
      lua = true;
      options = {
        silent = true;
        expr = true;
        desc = "Scroll Backward";
      };
    }
  ];
}
