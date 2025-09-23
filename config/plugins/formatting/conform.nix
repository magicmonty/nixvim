{pkgs, ...}: {
  extraPackages = with pkgs; [
    stylua
    alejandra
    clang-tools
    shfmt
    nodePackages.prettier
    prettierd
    yamllint
    yamlfmt
    libxml2
  ];
  plugins.conform-nvim = {
    enable = true;
    luaConfig.post =
      # lua
      ''
        vim.api.nvim_create_user_command("ConformDisable", function(args)
          if args.bang then
            -- ConformDisable! will disable autoformat just for this buffer
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end, {
          desc = "Disable autoformat on save",
          bang = true
        })

        vim.api.nvim_create_user_command("ConformEnable", function()
          vim.b.disable_autoformat = false
          vim.g.disable_autoformat = false
        end, {
            desc = "Re-enable autoformat on save"
        })

        vim.api.nvim_create_user_command("ConformToggle", function(args)
          if vim.b.disable_autoformat or vim.g.disable_autoformat then
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
          elseif args.bang then
            vim.b.disable_autoformat = true
          else
            vim.g.disable_autoformat = true
          end
        end, {
            desc = "Toggle  autoformat on save",
            bang = true
        })
      '';
    settings = {
      format_on_save.__raw =
        # lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            return { timeout_ms = 3000, lsp_format = "fallback" }
          end
        '';

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
        json = ["prettierd" "prettier"];
        c = ["clang-format"];
        cpp = ["clang-format"];
        css = ["prettierd" "prettier"];
        go = ["gofmt"];
        javascript = ["prettierd" "prettier"];
        javascriptreact = ["prettierd" "prettier"];
        typescript = ["prettierd" "prettier"];
        typescriptreact = ["prettierd" "prettier"];
        markdown = ["markdownlint"];
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
    {
      mode = ["n"];
      key = "<leader>uf";
      action = ":ConformToggle<cr>";
      options = {
        desc = "Toggle formatting";
        silent = true;
      };
    }
  ];
}
