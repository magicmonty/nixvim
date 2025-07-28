{pkgs, ...}: {
  extraPackages = with pkgs; [
    lynx
  ];
  plugins = {
    copilot-cmp = {
      enable = true;
      settings = {
        events = [
          "InsertEnter"
          "LspAttach"
        ];
        fix_pairs = false;
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

    cmp.settings.sources = [
      {
        name = "copilot";
        keywordLength = 5;
      }
    ];
  };
}
