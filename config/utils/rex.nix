# lua
''
  local token = vim.env.OSC7577_TOKEN
  vim.env.OSC7577_TOKEN = nil

  vim.api.nvim_create_autocmd("SessionWritePost", {
    callback = function()
      if not token then return end
      local argv = { "nvim", "-S", vim.v.this_session }
      for i, arg in ipairs(argv) do argv[i] = vim.base64.encode(arg) end
      -- This process is Neovim's server. The terminal runs its parent, the TUI.
      local body = ("pid=%d:time=%d:argv=%s"):format(
        vim.uv.os_getppid(), os.time(), table.concat(argv, ","))
      local mac = vim.fn.sha256(body .. ":" .. token)
      io.stderr:write("\27]7577;", body, ":mac=", mac, "\27\\")
    end,
  })
''
