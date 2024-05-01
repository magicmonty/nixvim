{
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    disabledFiletypes.statusline = [
      "dashboard"
      "alpha"
      "starter"
    ];
    extensions = [
      "neo-tree"
    ];
    sections = {
      lualine_a = ["mode"];
      lualine_b = ["branch"];

      lualine_c = [
        {
          name = "diagnostics";
          extraConfig = {
            symbols = {
              error = "e";
              warn = "w";
              info = "i";
              hint = "h";
            };
          };
        }
        {
          name = "filetype";
          extraConfig = {
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          };
        }
      ];
      lualine_x = [
        {
          name = {
            __raw =
              # lua
              ''
                function()
                  return require("noice").api.status.command.get()
                end
              '';
          };
          extraConfig = {
            cond = {
              __raw =
                # lua
                ''
                  function()
                    return package.loaded["noice"] and require("noice").api.status.command.has()
                  end
                '';
            };
          };
        }

        {
          name = {
            __raw =
              # lua
              ''
                function()
                  return require("noice").api.status.mode.get()
                end
              '';
          };
          extraConfig = {
            cond = {__raw = "function() return package.loaded['noice'] and require('noice').api.status.mode.has() end";};
          };
        }

        {
          name = {__raw = "function() return '  ' .. require('dap').status() end";};
          extraConfig = {
            cond = {__raw = "function () return package.loaded['dap'] and require('dap').status() ~= '' end";};
          };
        }

        {
          name = "diff";
          extraConfig = {
            symbols = {
              added = "+";
              modified = "~";
              removed = "-";
            };
            source = {
              __raw =
                # lua
                ''
                  function()
                    local gitsigns = vim.b.gitsigns_status_dict
                    if gitsigns then
                      return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed
                      }
                    end
                  end
                '';
            };
          };
        }
      ];

      lualine_y = [
        {
          name = "progress";
          extraConfig = {
            separator = " ";
            padding = {
              left = 1;
              right = 0;
            };
          };
        }
        {
          name = "location";
          extraConfig = {
            padding = {
              left = 0;
              right = 1;
            };
          };
        }
      ];
      lualine_z = [
        {
          name = {
            __raw =
              # lua
              ''
                function()
                  return " " .. os.date("%R")
                end
              '';
          };
        }
      ];
    };
  };
}
