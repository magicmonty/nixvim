{pkgs, ...}: {
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
      action =
        # lua
        ''
          function()
            require('spectre').open()
          end
        '';
      lua = true;
      options = {desc = "Replace in files (Spectre)";};
    }
  ];
}
