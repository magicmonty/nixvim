{
  plugins.conform-nvim = {
    enable = true;
    formatOnSave = ''
      {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_fallback = true,
      }
    '';
    formatters = {
      injected = {
        options = {
          ignore_errors = true;
        };
      };
    };

    formattersByFt = {
      lua = ["stylua"];
      nix = ["alejandra"];
      sh = ["shfmt"];
    };
  };

  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>cf";
      action = ''
        function()
          require("conform").format({ timeout_ms = 3000 })
        end
      '';
    }
    {
      mode = ["n" "v"];
      key = "<leader>cF";
      action = ''
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end
      '';
    }
    {
      # Escape terminal mode using ESC
      mode = "t";
      key = "<ESC>";
      action = "<C-\\><C-n>";
    }
  ];
}
