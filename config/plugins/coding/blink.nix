let
  icons = import ../../icons.nix {};
in {
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "enter";
        };
        appearance.kind_icons = icons.kinds;
        completion = {
          documentation = {
            auto_show = true;
          };
          ghost_text.enabled = true;
          menu = {
            auto_show = true;
            border = "rounded";
          };
        };
        signature.enabled = true;
        snippets.preset = "luasnip";
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "emoji"
            "buffer"
          ];

          providers = {
            emoji = {
              async = false;
              module = "blink-emoji";
              name = "emoji";
              score_offset = 15;
              opts = {
                insert = true;
              };
            };
          };
        };
      };
    };
    blink-copilot.enable = true;
    blink-emoji.enable = true;
  };
}
