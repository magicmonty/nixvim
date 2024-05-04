{
  plugins.neo-tree = {
    enable = true;
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

  keymaps = [
    {
      mode = "n";
      key = "<leader>.";
      action = "function() require('neo-tree.command').execute({ toggle = true, dir = NixVim.root.get() }) end";
      lua = true;
      options = {desc = "Toggle file explorer";};
    }
    {
      mode = "n";
      key = "<leader>ge";
      action = "function() require('neo-tree.command').execute({ toggle = true, source = 'git_status' }) end";
      lua = true;
      options = {desc = "Toggle Git explorer";};
    }
    {
      mode = "n";
      key = "<leader>be";
      action = "function() require('neo-tree.command').execute({ toggle = true, source = 'buffers' }) end";
      lua = true;
      options = {desc = "Toggle buffer explorer";};
    }
  ];
}
