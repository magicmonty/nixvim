{
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
      "       .-::-`                                                             "
    ];
    mkPadding = val: {
      type = "padding";
      inherit val;
    };
  in {
    enable = true;
    layout = [
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
          (mkButton "n" "<cmd>ene | startinsert<cr>" "  New File" "Operator")
          (mkPadding 1)
          (mkButton "r" "<cmd>Telescope oldfiles<cr>" "  Recent Files" "Operator")
          (mkPadding 1)
          (mkButton "g" "<cmd>Telescope live_grep<cr>" "  Find Text" "Operator")
          (mkPadding 1)
          (mkButton "q" "<cmd>qa<cr>" "  Quit" "String")
        ];
      }
      (mkPadding 2)
      {
        opts = {
          hl = "AlphaFooter";
          position = "center";
        };
        type = "text";
        val = "https://github.com/magicmonty/nixvim-config";
      }
    ];
  };
}
