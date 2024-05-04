let
  icons = import ../../icons.nix {};
in {
  plugins.lualine = {
    enable = true;
    globalstatus = true;
    disabledFiletypes.statusline = [
      "alpha"
    ];
    extensions = [
      "neo-tree"
    ];
    sections = {
      lualine_a = ["mode"];
      lualine_b = ["branch"];

      lualine_c = [
        # Shows name of root dir, if we are in a deeper subdirectory
        {
          name = {__raw = "NixVim.lualine.root_dir()[1]";};
          extraConfig = {
            cond = {__raw = "NixVim.lualine.root_dir().cond";};
            color = {__raw = "NixVim.lualine.root_dir().color";};
          };
        }
        {
          name = "diagnostics";
          extraConfig = {
            symbols = {
              error = icons.diagnostics.Error;
              warn = icons.diagnostics.Warn;
              info = icons.diagnostics.Info;
              hint = icons.diagnostics.Hint;
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
        {
          name = {__raw = "NixVim.lualine.pretty_path()";};
        }
      ];
      lualine_x = [
        {
          name = {__raw = ''function() return require("noice").api.status.command.get() end '';};
          extraConfig = {
            cond = {__raw = ''function() return package.loaded["noice"] and require("noice").api.status.command.has() end '';};
            color = {__raw = "NixVim.ui.fg('Statement')";};
          };
        }

        {
          name = {
            __raw =
              # lua
              ''
                function()
                  local icon = icons.kinds.Copilot
                  local status = require("copilot.api").status.data
                  return icon .. (status.message or "")
                end
              '';
          };
          extraConfig = {
            cond = {
              __raw =
                # lua
                ''
                  function()
                    if not package.loaded["copilot"] then
                      return
                    end
                    local ok, clients = pcall(NixVim.lsp.get_clients, { name = "copilot", bufnr = 0 })
                    if not ok then
                      return false
                    end
                    return ok and #clients > 0
                  end
                '';
            };
            color = {
              __raw =
                # lua
                ''
                  function()
                    local colors = {
                      [""] = NixVim.ui.fg("Special"),
                      ["Normal"] = NixVim.ui.fg("Special"),
                      ["Warning"] = NixVim.ui.fg("DiagnosticError"),
                      ["InProgress"] = NixVim.ui.fg("DiagnosticWarn"),
                    }
                    if not package.loaded["copilot"] then
                      return
                    end
                    local status = require("copilot.api").status.data
                    return colors[status.status] or colors[""]
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
            color = {__raw = "NixVim.ui.fg('Constant')";};
          };
        }

        {
          name = {__raw = "function() return '  ' .. require('dap').status() end";};
          extraConfig = {
            cond = {__raw = "function () return package.loaded['dap'] and require('dap').status() ~= '' end";};
            color = {__raw = "NixVim.ui.fg('Debug')";};
          };
        }

        {
          name = "diff";
          extraConfig = {
            symbols = {
              added = icons.git.added;
              modified = icons.git.modified;
              removed = icons.git.removed;
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
