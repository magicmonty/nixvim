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
''
