{config, ...}: {
  plugins.alpha = let
    header = [
      " "
      "            .:-`                                                          "
      "          `+oooo`                                                         "
      "          +-  :o+                                                         "
      "               /o-                                                        "
      "               .oo`                                                       "
      "               /oo:                dP                         oo          "
      "              `oo+o`               88                                     "
      "              :o:.o/      88d888b. 88d888b. .d8888b. 88d888b. dP .d8888b. "
      "             `oo` /o.     88'  `88 88'  `88 88'  `88 88'  `88 88 88'  `   "
      "             :o+  `oo` `  88.  .88 88    88 88.  .88 88    88 88 88.  ... "
      "     -/++++:.oo-   :oo++  88Y888P' dP    dP `88888P' dP    dP dP `88888P' "
      "    ++-..-:/ooo`    .-.   88                                              "
      " `--o+:------o+--`        dP                                              "
      "    `/oo+///++`                                                           "
      "       .-::-`             NixVim ${config.nixvim.flavour}                 "
    ];
    mkPadding = val: {
      type = "padding";
      inherit val;
    };
  in {
    enable = true;
    settings.layout = [
      (mkPadding 2)
      {
        opts = {
          hl = "AlphaHeader";
          position = "center";
        };
        type = "text";
        val = header;
      }
      (mkPadding 2)
      {
        type = "group";
        val = let
          mkButton = shortcut: cmd: val: hl: {
            type = "button";
            on_press.__raw = let
              button_cmd = builtins.replaceStrings ["<CMD>" "<CR>"] ["" ""] cmd;
            in
              #  lua
              ''
                function()
                  vim.cmd([[${button_cmd}]])
                end
              '';
            inherit val;
            opts = {
              inherit hl shortcut;
              keymap = [
                "n"
                shortcut
                cmd
                {}
              ];
              position = "center";
              cursor = "0";
              width = 40;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          };
        in [
          (mkButton "f" "<CMD>lua require('telescope.builtin').find_files({hidden = true})<CR>" "  Find File" "Operator")
          (mkPadding 1)
          (mkButton "e" "<CMD>Oil<CR>" "  Open File Explorer" "Operator")
          (mkPadding 1)
          (mkButton "n" "<CMD>ene | startinsert<CR>" "  New File" "Operator")
          (mkPadding 1)
          (mkButton "r" "<CMD>Telescope oldfiles<CR>" "  Recent Files" "Operator")
          (mkPadding 1)
          (mkButton "g" "<CMD>Telescope live_grep<CR>" "  Find Text" "Operator")
          (mkPadding 1)
          (mkButton "q" "<CMD>qa<CR>" "  Quit" "String")
        ];
      }
      (mkPadding 2)
      {
        opts = {
          hl = "AlphaFooter";
          position = "center";
        };
        type = "text";
        val = "https://github.com/magicmonty/nixvim";
      }
    ];
  };
}
