let
  icons = import ../../icons.nix {};
in {
  plugins.lualine = {
    enable = true;
    settings = {
      extensions = [
        "neo-tree"
      ];

      options = {
        disabled_filetypes.statusline = [
          "alpha"
        ];
        globalstatus = true;
      };

      sections = {
        lualine_a = [
          "mode"
        ];

        lualine_b = [
          "branch"
        ];

        lualine_c = [
          # Shows name of root dir, if we are in a deeper subdirectory
          {
            __unkeyed-1.__raw =
              # lua
              ''
                NixVim.lualine.root_dir()[1]
              '';

            cond.__raw =
              # lua
              ''
                NixVim.lualine.root_dir().cond
              '';
            color.__raw =
              # lua
              ''
                NixVim.lualine.root_dir().color
              '';
          }
          {
            __unkeyed-1 = "diagnostics";
            symbols = {
              error = icons.diagnostics.Error;
              warn = icons.diagnostics.Warn;
              info = icons.diagnostics.Info;
              hint = icons.diagnostics.Hint;
            };
          }
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
            separator = "";
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __unkeyed-1.__raw =
              # lua
              ''
                NixVim.lualine.pretty_path()
              '';
          }
        ];
        lualine_x = [
          {
            __unkeyed-1.__raw =
              # lua
              ''
                function()
                  return require("noice").api.status.command.get()
                end
              '';
            cond.__raw =
              # lua
              ''
                function()
                  return package.loaded["noice"] and require("noice").api.status.command.has()
                end
              '';
            color.__raw =
              # lua
              ''
                NixVim.ui.fg('Statement')
              '';
          }

          {
            __unkeyed-1.__raw =
              # lua
              ''
                function()
                  local icon = icons.kinds.Copilot
                  local status = require("copilot.api").status.data
                  return icon .. (status.message or "")
                end
              '';

            cond.__raw =
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

            color.__raw =
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
          }

          {
            __unkeyed-1.__raw =
              # lua
              ''
                function()
                  return require("noice").api.status.mode.get()
                end
              '';

            cond.__raw =
              # lua
              ''
                function()
                  return package.loaded['noice'] and require('noice').api.status.mode.has()
                end
              '';
            color.__raw =
              # lua
              ''
                NixVim.ui.fg('Constant')
              '';
          }

          {
            __unkeyed-1.__raw =
              # lua
              ''
                function()
                    return '  ' .. require('dap').status()
                  end
              '';
            cond.__raw =
              # lua
              ''
                function ()
                  return package.loaded['dap'] and require('dap').status() ~= '''
                end
              '';
            color.__raw =
              # lua
              ''
                NixVim.ui.fg('Debug')
              '';
          }

          {
            __unkeyed-1 = "diff";
            symbols = {
              inherit (icons.git) added;
              inherit (icons.git) modified;
              inherit (icons.git) removed;
            };

            source.__raw =
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
          }
        ];

        lualine_y = [
          {
            __unkeyed-1 = "progress";
            separator = " ";
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __unkeyed-1 = "location";
            padding = {
              left = 0;
              right = 1;
            };
          }
        ];
        lualine_z = [
          {
            __unkeyed-1.__raw =
              # lua
              ''
                function()
                  return " " .. os.date("%R")
                end
              '';
          }
        ];
      };
    };
  };
}
