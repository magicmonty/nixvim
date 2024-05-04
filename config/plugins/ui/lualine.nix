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

  extraConfigLuaPre =
    # lua
    ''
      vim.uv = vim.uv or vim.loop

      NixVim = {}

      function NixVim.pretty_trace(opts)
        opts = opts or {}
        local trace = {}
        local level = opts.level or 2
        while true do
          local info = debug.getinfo(level, "Sln")
          if not info then
            break
          end
          if info.what ~= "C" then
            local source = info.source:sub(2)
            source = vim.fn.fnamemodify(source, ":p:~:.")
            local line = "  - " .. source .. ":" .. info.currentline
            if info.name then
              line = line .. " _in_ **" .. info.name .. "**"
            end
            table.insert(trace, line)
          end
          level = level + 1
        end
        return #trace > 0 and ("\n\n# stacktrace:\n" .. table.concat(trace, "\n")) or ""
      end

      function NixVim.notify(msg, opts)
        if vim.in_fast_event() then
          return vim.schedule(function()
            NixVim.notify(msg, opts)
          end)
        end

        opts = opts or {}
        if type(msg) == "table" then
          msg = table.concat(
            vim.tbl_filter(function(line)
              return line or false
            end, msg),
            "\n"
          )
        end
        if opts.stacktrace then
          msg = msg .. NixVim.pretty_trace({ level = opts.stacklevel or 2 })
        end
        local lang = opts.lang or "markdown"
        local n = opts.once and vim.notify_once or vim.notify
        n(msg, opts.level or vim.log.levels.INFO, {
          on_open = function(win)
            local ok = pcall(function()
              vim.treesitter.language.add("markdown")
            end)
            if not ok then
              pcall(require, "nvim-treesitter")
            end
            vim.wo[win].conceallevel = 3
            vim.wo[win].concealcursor = ""
            vim.wo[win].spell = false
            local buf = vim.api.nvim_win_get_buf(win)
            if not pcall(vim.treesitter.start, buf, lang) then
              vim.bo[buf].filetype = lang
              vim.bo[buf].syntax = lang
            end
          end,
          title = opts.title or "NixVim",
        })
      end

      function NixVim.error(msg, opts)
        opts = opts or {}
        opts.level = vim.log.levels.ERROR
        NixVim.notify(msg, opts)
      end

      function NixVim.info(msg, opts)
        opts = opts or {}
        opts.level = vim.log.levels.INFO
        NixVim.notify(msg, opts)
      end

      function NixVim.warn(msg, opts)
        opts = opts or {}
        opts.level = vim.log.levels.WARN
        NixVim.notify(msg, opts)
      end

      function NixVim.debug(msg, opts)
        if not require("lazy.core.config").options.debug then
          return
        end
        opts = opts or {}
        if opts.title then
          opts.title = "lazy.nvim: " .. opts.title
        end
        if type(msg) == "string" then
          NixVim.notify(msg, opts)
        else
          opts.lang = "lua"
          NixVim.notify(vim.inspect(msg), opts)
        end
      end

      NixVim.inject = {}
      function NixVim.inject.args(fn, wrapper)
        return function(...)
          if wrapper(...) == false then
            return
          end
          return fn(...)
        end
      end

      function NixVim.inject.get_upvalue(func, name)
        local i = 1
        while true do
          local n, v = debug.getupvalue(func, i)
          if not n then
            break
          end
          if n == name then
            return v
          end
          i = i + 1
        end
      end

      NixVim.lualine = {}
      NixVim.ui = {}

      function NixVim.is_win()
        return vim.uv.os_uname().sysname:find("Windows") ~= nil
      end

      function NixVim.norm(path)
        if path:sub(1, 1) == "~" then
          local home = vim.uv.os_homedir()
          if home:sub(-1) == "\\" or home:sub(-1) == "/" then
            home = home:sub(1, -2)
          end
          path = home .. path:sub(2)
        end
        path = path:gsub("\\", "/"):gsub("/+", "/")
        return path:sub(-1) == "/" and path:sub(1, -2) or path
      end

      function NixVim.ui.color(name, bg)
        local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name, link = false })
          or vim.api.nvim_get_hl_by_name(name, true)

        local color = nil
        if hl then
          if bg then
            color = hl.bg or hl.background
          else
            color = hl.fg or hl.foreground
          end
        end
        return color and string.format("#%06x", color) or nil
      end

      function NixVim.ui.fg(name)
        local color = NixVim.ui.color(name)
        return color and { fg = color } or nil
      end

      NixVim.lsp = {}
      function NixVim.lsp.get_clients(opts)
        local ret = {}
        if vim.lsp.get_clients then
          ret = vim.lsp.get_clients(opts)
        else
          ret = vim.lsp.get_active_clients(opts)
          if opts and opts.method then
            ret = vim.tbl_filter(function(client)
              return client.supports_method(opts.method, { bufnr = opts.bufnr })
            end, ret)
          end
        end
        return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
      end

      NixVim.root = {}
      NixVim.root.cache = {}
      NixVim.root.spec = { "lsp", { ".git", "lua" }, "cwd" }
      NixVim.root.cwd = function()
        return NixVim.root.realpath(vim.uv.cwd()) or ""
      end

      NixVim.root.realpath = function(path)
        if path == "" or path == nil then
          return nil
        end
        path = vim.uv.fs_realpath(path) or path
        return NixVim.norm(path)
      end

      NixVim.root.detectors = {}
      function NixVim.root.detectors.cwd()
        return { vim.uv.cwd() }
      end

      function NixVim.root.detectors.lsp(buf)
        local bufpath = NixVim.root.bufpath(buf)

        if not bufpath then
          return {}
        end

        local roots = {}

        for _, client in pairs(NixVim.lsp.get_clients({ bufnr = buf })) do
          -- only check workspace folders, since we're not interested in clients
          -- running in single file mode
          local workspace = client.config.workspace_folders
          for _, ws in pairs(workspace or {}) do
            roots[#roots + 1] = vim.uri_to_fname(ws.uri)
          end
        end
        return vim.tbl_filter(function(path)
          path = NixVim.norm(path)
          return path and bufpath:find(path, 1, true) == 1
        end, roots)
      end

      function NixVim.root.detectors.pattern(buf, patterns)
        patterns = type(patterns) == "string" and { patterns } or patterns
        local path = NixVim.root.bufpath(buf) or vim.uv.cwd()
        local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]
        return pattern and { vim.fs.dirname(pattern) } or {}
      end

      function NixVim.root.detect(opts)
        opts = opts or {}
        opts.spec = opts.spec or type(vim.g.root_spec) == "table" and vim.g.root_spec or NixVim.root.spec
        opts.buf = (opts.buf == nil or opts.buf == 0) and vim.api.nvim_get_current_buf() or opts.buf

        local ret = {}
        for _, spec in ipairs(opts.spec) do
          local paths = NixVim.root.resolve(spec)(opts.buf)
          paths = paths or {}
          paths = type(paths) == "table" and paths or { paths }
          local roots = {}
          for _, p in ipairs(paths) do
            local pp = NixVim.root.realpath(p)
            if pp and not vim.tbl_contains(roots, pp) then
              roots[#roots + 1] = pp
            end
          end
          table.sort(roots, function(a, b)
            return #a > #b
          end)
          if #roots > 0 then
            ret[#ret + 1] = { spec = spec, paths = roots }
            if opts.all == false then
              break
            end
          end
        end
        return ret
      end

      function NixVim.root.resolve(spec)
        if NixVim.root.detectors[spec] then
          return NixVim.root.detectors[spec]
        elseif type(spec) == "function" then
          return spec
        end
        return function(buf)
          return NixVim.root.detectors.pattern(buf, spec)
        end
      end

      function NixVim.root.info()
        local spec = type(vim.g.root_spec) == "table" and vim.g.root_spec or NixVim.root.spec

        local roots = NixVim.root.detect({ all = true })
        local lines = {}
        local first = true
        for _, root in ipairs(roots) do
          for _, path in ipairs(root.paths) do
            lines[#lines + 1] = ("- [%s] `%s` **(%s)**"):format(
              first and "x" or " ",
              path,
              type(root.spec) == "table" and table.concat(root.spec, ", ") or root.spec
            )
            first = false
          end
        end
        lines[#lines + 1] = "```lua"
        lines[#lines + 1] = "vim.g.root_spec = " .. vim.inspect(spec)
        lines[#lines + 1] = "```"
        NixVim.info(lines, { title = "NixVim Roots" })
        return roots[1] and roots[1].paths[1] or vim.uv.cwd()
      end

      function NixVim.root.bufpath(buf)
        return NixVim.root.realpath(vim.api.nvim_buf_get_name(assert(buf)))
      end

      function NixVim.root.get(opts)
        local buf = vim.api.nvim_get_current_buf()
        local ret = NixVim.root.cache[buf]
        if not ret then
          local roots = NixVim.root.detect({ all = false })
          ret = roots[1] and roots[1].paths[1] or vim.uv.cwd()
          NixVim.root.cache[buf] = ret
        end
        if opts and opts.normalize then
          return ret
        end
        return NixVim.is_win() and ret:gsub("/", "\\") or ret
      end

      NixVim.lualine.root_dir = function(opts)
        opts = vim.tbl_extend("force", {
          cwd = false,
          subdirectory = true,
          parent = true,
          other = true,
          icon = "󱉭 ",
          color = NixVim.ui.fg("Special")
        }, opts or {})

        local function get()
          local cwd = NixVim.root.cwd()
          local root = NixVim.root.get({ normalize = true })
          local name = vim.fs.basename(root)

          if root == cwd then
            -- root is cwd
            return opts.cwd and name
          elseif root:find(cwd, 1, true) == 1 then
            -- root is subdirectory of cwd
            return opts.subdirectory and name
          elseif cwd:find(root, 1, true) == 1 then
            -- root is parent directory of cwd
            return opts.parent and name
          else
            -- root and cwd are not related
            return opts.other and name
          end
        end

        return {
          function()
            return (opts.icon and opts.icon .. " ") .. get()
          end,
          cond = function()
            return type(get()) == "string"
          end,
          color = opts.color,
        }
      end

      function NixVim.lualine.format(component, text, hl_group)
        if not hl_group or hl_group == "" then
          return text
        end
        component.hl_cache = component.hl_cache or {}
        local lualine_hl_group = component.hl_cache[hl_group]
        if not lualine_hl_group then
          local utils = require("lualine.utils.utils")
          local gui = vim.tbl_filter(function(x)
            return x
          end, {
            utils.extract_highlight_colors(hl_group, "bold") and "bold",
            utils.extract_highlight_colors(hl_group, "italic") and "italic",
          })

          lualine_hl_group = component:create_hl({
            fg = utils.extract_highlight_colors(hl_group, "fg"),
            gui = #gui > 0 and table.concat(gui, ",") or nil,
          }, "LV_" .. hl_group) --[[@as string]]
          component.hl_cache[hl_group] = lualine_hl_group
        end
        return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
      end

      function NixVim.lualine.pretty_path(opts)
        opts = vim.tbl_extend("force", {
          relative = "cwd",
          modified_hl = "MatchParen",
          directory_hl = "",
          filename_hl = "Bold",
          modified_sign = "",
          length = 3,
        }, opts or {})

        return function(self)
          local path = vim.fn.expand("%:p")

          if path == "" then
            return ""
          end

          local root = NixVim.root.get({ normalize = true })
          local cwd = NixVim.root.cwd()

          if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
            path = path:sub(#cwd + 2)
          else
            path = path:sub(#root + 2)
          end

          local sep = package.config:sub(1, 1)
          local parts = vim.split(path, "[\\/]")

          if opts.length == 0 then
            parts = parts
          elseif #parts > opts.length then
            parts = { parts[1], "…", table.concat({ unpack(parts, #parts - opts.length + 2, #parts) }, sep) }
          end

          if opts.modified_hl and vim.bo.modified then
            parts[#parts] = parts[#parts] .. opts.modified_sign
            parts[#parts] = NixVim.lualine.format(self, parts[#parts], opts.modified_hl)
          else
            parts[#parts] = NixVim.lualine.format(self, parts[#parts], opts.filename_hl)
          end

          local dir = ""
          if #parts > 1 then
            dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
            dir = NixVim.lualine.format(self, dir .. sep, opts.directory_hl)
          end
          return dir .. parts[#parts]
        end
      end

      function NixVim.root.setup()
        vim.api.nvim_create_user_command("NixVimRoot", function()
            NixVim.root.info()
          end, { desc = "NixVim roots for the current buffer" })

          vim.api.nvim_create_autocmd({ "LspAttach", "BufWritePost", "DirChanged" }, {
            group = vim.api.nvim_create_augroup("nixvim_root_cache", { clear = true }),
            callback = function(event)
              NixVim.root.cache[event.buf] = nil
            end,
          })
      end
    '';

  extraConfigLuaPost = "NixVim.root.setup()";
}
