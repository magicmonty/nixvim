{
  plugins.oil = {
    enable = true;
    settings = {
      columns = ["icon" "size"];
      default_file_explorer = true;
      use_default_keymaps = false;
      keymaps = {
        "<CR>" = "actions.select";
        "<BS>" = "actions.open_cwd";
        "q" = "actions.close";
        "<leader>." = "actions.close";
        "<C-h>" = "actions.select_split";
        "<C-v>" = "actions.select_vsplit";
        "<C-p>" = "actions.preview";
        "<C-r>" = "actions.refresh";
        "gcd" = "actions.cd";
        "H" = "actions.toggle_hidden";
        "gs" = "actions.change_sort";
        "gx" = "actions.open_external";
      };
    };
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>.";
      action.__raw =
        # lua
        ''
          function()
            require('oil').toggle_float(NixVim.root.get())
          end
        '';
      options = {desc = "Toggle file explorer";};
    }
  ];
}
