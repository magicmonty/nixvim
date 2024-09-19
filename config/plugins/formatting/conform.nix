{pkgs, ...}: {
  extraPackages = with pkgs; [
    stylua
    alejandra
    shfmt
    nodePackages.prettier
    prettierd
    yamllint
    yamlfmt
    libxml2
  ];
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        timeout_ms = 3000;
        lsp_format = "fallback";
      };
      formatters = {
        injected = {
          options = {
            ignore_errors = true;
          };
        };
      };

      formatters_by_ft = {
        lua = ["stylua"];
        nix = ["alejandra"];
        sh = ["shfmt"];
        html = ["prettierd" "prettier"];
        css = ["prettierd" "prettier"];
        go = ["gofmt"];
        javascript = ["prettierd" "prettier"];
        javascriptreact = ["prettierd" "prettier"];
        typescript = ["prettierd" "prettier"];
        typescriptreact = ["prettierd" "prettier"];
        markdown = [];
        yaml = ["yamllint" "yamlfmt"];
        xml = ["xmllint"];
      };
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
      options = {
        desc = "Format";
      };
    }
    {
      mode = ["n" "v"];
      key = "<leader>cF";
      action = ''
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end
      '';
      options = {
        desc = "Format injected";
      };
    }
  ];
}
