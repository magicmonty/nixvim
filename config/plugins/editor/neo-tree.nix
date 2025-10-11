{
  plugins.neo-tree = {
    enable = true;
    settings = {
      closeIfLastWindow = true;
      eventHandlers = {
        file_opened =
          # lua
          ''
            function()
              require('neo-tree.command').execute({ action = "close" })
            end
          '';
        file_moved =
          # lua
          ''
            function(data)
              NixVim.lsp.on_rename(data.source, data.destination)
            end
          '';
        file_renamed =
          # lua
          ''
            function(data)
              NixVim.lsp.on_rename(data.source, data.destination)
            end
          '';
      };
      defaultComponentConfigs = {
        gitStatus.symbols = {
          untracked = "★";
          unstaged = "✗";
          staged = "✓";
          ignored = "◌";
          deleted = "";
          renamed = "➜";
          conflict = "";
        };
        indent = {
          withExpanders = true;
          expanderCollapsed = "";
          expanderExpanded = "";
          expanderHighlight = "NeoTreeExpander";
        };
      };
      extraOptions = {
        open_files_do_not_replace_types = ["terminal" "Trouble" "trouble" "qf" "Outline"];
        filesystem = {
          bind_to_cwd = false;
          follow_current_file.enabled = true;
          use_libuv_file_watcher = true;
        };
      };
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>ge";
      action.__raw =
        # lua
        ''
          function()
            require('neo-tree.command').execute({ toggle = true, source = 'git_status' })
          end
        '';
      options = {desc = "Toggle Git explorer";};
    }
    {
      mode = "n";
      key = "<leader>be";
      action.__raw =
        # lua
        ''
          function()
            require('neo-tree.command').execute({ toggle = true, source = 'buffers' })
          end
        '';
      options = {desc = "Toggle buffer explorer";};
    }
  ];
}
