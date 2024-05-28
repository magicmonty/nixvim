_: {
  plugins.spectre = {
    enable = true;
    settings = {
      open_cmd = "noswapfile vnew";
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>sr";
      action.__raw =
        # lua
        ''
          function()
            require('spectre').open()
          end
        '';
      options = {desc = "Replace in files (Spectre)";};
    }
  ];
}
