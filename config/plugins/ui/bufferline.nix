{
  plugins.bufferline = {
    enable = true;
    closeCommand = {
      __raw =
        # lua
        ''
          function(n)
            require("mini.bufremove").delete(n, false)
          end
        '';
    };
    rightMouseCommand = {
      __raw =
        # lua
        ''
          function(n)
            require("mini.bufremove").delete(n, false)
          end
        '';
    };
    diagnostics = "nvim_lsp";
    alwaysShowBufferline = false;
    diagnosticsIndicator =
      # lua
      ''
        function(_, _, diag)
          local icn = icons.diagnostics
          local ret = (diag.error and icn.Error .. diag.error .. " " or "")
            .. (diag.warning and icn.Warn .. diag.warning or "")
          return vim.trim(ret)
        end
      '';
    offsets = [
      {
        filetype = "neo-tree";
        text = "File explorer";
        highlight = "Directory";
        text_align = "left";
      }
    ];
  };
}
