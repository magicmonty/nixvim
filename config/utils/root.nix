(
  # lua
  ''
    NixVim.root = {}
    NixVim.root.cache = {}
    NixVim.root.spec = { "lsp", { ".git", "lua" }, "cwd" }
    NixVim.root.detectors = {}

    function NixVim.root.cwd()
      return NixVim.root.realpath(vim.uv.cwd()) or ""
    end

    NixVim.root.realpath = function(path)
      if path == "" or path == nil then
        return nil
      end
      path = vim.uv.fs_realpath(path) or path
      return NixVim.norm(path)
    end

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

  ''
)
