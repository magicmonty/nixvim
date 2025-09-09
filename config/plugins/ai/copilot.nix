{pkgs, ...}: {
  extraPackages = with pkgs; [
    lynx
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
