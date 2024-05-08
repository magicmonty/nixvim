{
  plugins = {
    copilot-cmp.enable = true;
    copilot-lua = {
      enable = true;
      suggestion.enabled = false;
      panel.enabled = false;
      filetypes = {
        markdown = true;
        help = true;
      };
    };

    cmp.settings.sources = [
      {
        name = "copilot";
        keywordLength = 5;
      }
    ];

    extraConfigLua =
      # lua
      ''
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      '';
  };
}
