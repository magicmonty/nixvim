{pkgs, ...}: {
  extraPackages = with pkgs; [
    lynx
  ];
  keymaps = [
    {
      mode = "n";
      key = "<leader>ai";
      action = "<cmd>CopilotChatToggle<CR>";
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

    copilot-chat = {
      enable = true;
      settings = {
        debug = true;
        show_help = true;
        model = "claude-opus-4.6";
        window = {
          layout = "float";
        };
        auto_follow_cursor = false;
      };
    };

    copilot-lua = {
      enable = true;

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
