(
  # lua
  ''
    NixVim.ui = {}

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
  ''
)
