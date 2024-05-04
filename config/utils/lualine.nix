(
  # lua
  ''
    NixVim.lualine = {}

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
  ''
)
