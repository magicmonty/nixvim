{pkgs, ...}: {
  extraPackages = with pkgs; [
    lynx
  ];
  keymaps = [
    {
      mode = "v";
      key = "<leader>ai";
      action = "<cmd>CodeCompanionChat Add<CR>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ai";
      action = "<cmd>CodeCompanionChat Toggle<CR>";
      options = {
        noremap = true;
        silent = true;
      };
    }
  ];

  plugins = {
    blink-cmp.settings.sources = {
      default = [
        "lsp"
        "path"
        "snippets"
        "emoji"
        "buffer"
        "copilot"
      ];

      providers = {
        copilot = {
          async = true;
          module = "blink-copilot";
          name = "copilot";
          score_offset = 100;
          opts = {
            max_completions = 3;
            max_attempts = 4;
            kind = "Copilot";
            debounce = 750;
            auto_refresh = {
              backward = true;
              forward = true;
            };
          };
        };
      };
    };

    codecompanion = {
      enable = true;
      settings = {
        interactions = {
          chat = {
            adapter = "copilot";
            model = "claude-sonnet-4.6";
          };
          inline = {
            adapter = "copilot";
            model = "claude-sonnet-4.6";
          };
          cmd = {
            adapter = "copilot";
            model = "claude-sonnet-4.6";
          };
          background = {
            adapter = "copilot";
            model = "claude-sonnet-4.6";
          };
        };
      };
    };

    copilot-chat = {
      enable = false;
    };

    copilot-lua = {
      enable = false;

      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
        filetypes = {
          "." = false;
          gitcommit = false;
          gitrebase = false;
          help = false;
          markdown = true;
          yaml = true;
        };
      };

      luaConfig.post =
        # lua
        ''
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        '';
    };
  };
}
