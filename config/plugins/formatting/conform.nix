{pkgs, ...}: {
  extraPackages = with pkgs; [
    stylua
    alejandra
    shfmt
    nodePackages.prettier
    prettierd
    yamllint
    yamlfmt
  ];
  plugins.conform-nvim = {
    enable = true;
    formatOnSave = {
      timeoutMs = 3000;
      lspFallback = true;
    };
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
      html = [["prettierd" "prettier"]];
      css = [["prettierd" "prettier"]];
      javascript = [["prettierd" "prettier"]];
      javascriptreact = [["prettierd" "prettier"]];
      typescript = [["prettierd" "prettier"]];
      typescriptreact = [["prettierd" "prettier"]];
      markdown = [];
      yaml = [["yamllint" "yamlfmt"]];
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
