# lua
''
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

  function NixVim.lsp.on_rename(from, to)
    local clients = NixVim.lsp.get_clients()
    for _, client in ipairs(clients) do
      if client.supports_method("workspace/willRenameFiles") then
        local resp = client.request_sync("workspace/willRenameFiles", {
          files = {
            {
              oldUri = vim.uri_from_fname(from),
              newUri = vim.uri_from_fname(to),
            },
          },
        }, 1000, 0)
        if resp and resp.result ~= nil then
          vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
        end
      end
    end
  end

  function NixVim.lsp.has(buffer, method)
    method = method:find("/") and method or "textDocument/" .. method
    local clients = NixVim.lsp.get_clients({ bufnr = buffer })
    for _, client in ipairs(clients) do
      if client.supports_method(method) then
        return true
      end
    end
    return false
  end
''
