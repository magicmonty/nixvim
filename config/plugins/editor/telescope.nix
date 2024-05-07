{
  plugins.telescope = {
    enable = true;
    extensions.fzf-native.enable = true;
    settings = {
      prompt_prefix = " ";
      selection_caret = " ";
      get_selection_window = {
        __raw =
          # lua
          ''
            function()
              local wins = vim.api.nvim_list_wins()
              table.insert(wins, 1, vim.api.nvim_get_current_win())
              for _, win in ipairs(wins) do
                local buf = vim.api.nvim_win_get_buf(win)
                if vim.bo[buf].buftype == "" then
                  return win
                end
              end
              return 0
            end
          '';
      };
      mappings = {
        i = {
          "<C-t>" = {
            __raw =
              # lua
              ''
                function(...)
                  require("trouble.providers.telescope").open_with_trouble(...)
                end
              '';
          };
          "<a-t>" = {
            __raw =
              # lua
              ''
                function(...)
                  require("trouble.providers.telescope").open_selected_with_trouble(...)
                end
              '';
          };
          "<C-Down>" = {
            __raw = "require('telescope.actions').cycle_history_next";
          };
          "<C-Up>" = {
            __raw = "require('telescope.actions').cycle_history_prev";
          };
          "<C-f>" = {
            __raw = "require('telescope.actions').preview_scrolling_down";
          };
          "<C-d>" = {
            __raw = "require('telescope.actions').preview_scrolling_up";
          };
          "<C-s>" = {
            __raw =
              # lua
              ''
                function(prompt_bufnr)
                  require("flash").jump({
                    pattern = "^",
                    label = { after = { 0, 0 } },
                    search = {
                      mode = "search",
                      exclude = {
                        function(win)
                          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                        end,
                      },
                    },
                    action = function(match)
                      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                      picker:set_selection(match.pos[1] - 1)
                    end,
                  })
                end
              '';
          };
        };
        n = {
          "q" = {
            __raw = "require('telescope.actions').close";
          };
          "s" = {
            __raw =
              # lua
              ''
                function(prompt_bufnr)
                  require("flash").jump({
                    pattern = "^",
                    label = { after = { 0, 0 } },
                    search = {
                      mode = "search",
                      exclude = {
                        function(win)
                          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                        end,
                      },
                    },
                    action = function(match)
                      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                      picker:set_selection(match.pos[1] - 1)
                    end,
                  })
                end
              '';
          };
        };
      };
    };
  };

  keymaps = [
    {
      key = "<leader>,";
      action = "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>";
      options = {
        desc = "Switch Buffer";
      };
    }
    {
      key = "<leader>:";
      action = "<cmd>Telescope command_history<cr>";
      options = {desc = "Command History";};
    }
    # find
    {
      key = "<leader>fb";
      action = "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>";
      options = {desc = "Buffers";};
    }
    {
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<cr>";
      options = {desc = "Live grep";};
    }
    {
      key = "<leader>fG";
      action = "<cmd>Telescope git_files<cr>";
      options = {desc = "Find Files (git-files)";};
    }
    {
      key = "<leader>fr";
      action = "<cmd>Telescope oldfiles<cr>";
      options = {desc = "Recent";};
    }
    # git
    {
      key = "<leader>gc";
      action = "<cmd>Telescope git_commits<CR>";
      options = {desc = "Commits";};
    }
    {
      key = "<leader>gs";
      action = "<cmd>Telescope git_status<CR>";
      options = {desc = "Status";};
    }
    # search
    {
      key = "<leader>s\"";
      action = "<cmd>Telescope registers<cr>";
      options = {desc = "Registers";};
    }
    {
      key = "<leader>sa";
      action = "<cmd>Telescope autocommands<cr>";
      options = {desc = "Auto Commands";};
    }
    {
      key = "<leader>sb";
      action = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
      options = {desc = "Buffer";};
    }
    {
      key = "<leader>sc";
      action = "<cmd>Telescope command_history<cr>";
      options = {desc = "Command History";};
    }
    {
      key = "<leader>sC";
      action = "<cmd>Telescope commands<cr>";
      options = {desc = "Commands";};
    }
    {
      key = "<leader>sd";
      action = "<cmd>Telescope diagnostics bufnr=0<cr>";
      options = {desc = "Document Diagnostics";};
    }
    {
      key = "<leader>sD";
      action = "<cmd>Telescope diagnostics<cr>";
      options = {desc = "Workspace Diagnostics";};
    }
    {
      key = "<leader>sh";
      action = "<cmd>Telescope help_tags<cr>";
      options = {desc = "Help Pages";};
    }
    {
      key = "<leader>sH";
      action = "<cmd>Telescope highlights<cr>";
      options = {desc = "Search Highlight Groups";};
    }
    {
      key = "<leader>sk";
      action = "<cmd>Telescope keymaps<cr>";
      options = {desc = "Key Maps";};
    }
    {
      key = "<leader>sM";
      action = "<cmd>Telescope man_pages<cr>";
      options = {desc = "Man Pages";};
    }
    {
      key = "<leader>sm";
      action = "<cmd>Telescope marks<cr>";
      options = {desc = "Jump to Mark";};
    }
    {
      key = "<leader>sn";
      action = "<cmd>Telescope notify<cr>";
      options = {desc = "Show notifications history";};
    }
    {
      key = "<leader>so";
      action = "<cmd>Telescope vim_options<cr>";
      options = {desc = "Options";};
    }
    {
      key = "<leader>;";
      action = "<cmd>Telescope resume<cr>";
      options = {desc = "Resume";};
    }
  ];
}
