{
  plugins.bufferline = {
    enable = true;
    settings.options = {
      close_command = {
        __raw =
          # lua
          ''
            function(n)
              require("mini.bufremove").delete(n, false)
            end
          '';
      };
      right_mouse_command = {
        __raw =
          # lua
          ''
            function(n)
              require("mini.bufremove").delete(n, false)
            end
          '';
      };
      diagnostics = "nvim_lsp";
      always_show_bufferline = false;
      diagnostics_indicator =
        # lua
        ''
          function(_, _, diag)
            local icn = icons.diagnostics
            local ret = (diag.error and icn.Error .. diag.error .. " " or "")
              .. (diag.warning and icn.Warn .. diag.warning or "")
            return vim.trim(ret)
          end
        '';
      offsets = [
        {
          filetype = "neo-tree";
          text = "File explorer";
          highlight = "Directory";
          text_align = "left";
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineTogglePin<cr>";
      options = {
        noremap = true;
        silent = true;
        desc = "Toggle pin buffer";
      };
    }
    {
      mode = "n";
      key = "<leader>bP";
      action = "<cmd>BufferLineGroupClose ungrouped<cr>";
      options = {
        noremap = true;
        silent = true;
        desc = "Delete non-pinned buffers";
      };
    }
    {
      mode = "n";
      key = "<leader>br";
      action = "<cmd>BufferLineCloseRight<cr>";
      options = {
        noremap = true;
        silent = true;
        desc = "Delete buffers to the right";
      };
    }
    {
      mode = "n";
      key = "<leader>bl";
      action = "<cmd>BufferLineCloseLeft<cr>";
      options = {
        noremap = true;
        silent = true;
        desc = "Delete buffers to the left";
      };
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>BufferLineCloseOthers<cr>";
      options = {
        noremap = true;
        silent = true;
        desc = "Delete other buffers";
      };
    }
  ];
}
