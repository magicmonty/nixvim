{
  plugins.mini.modules.surround = {
    mappings = {
      add = "ys";
      delete = "ds";
      find = "gsf";
      find_left = "gsF";
      highlight = "gsh";
      replace = "cs";
      update_n_lines = "gsn";
    };

    silent = true;
  };

  keymaps = [
    {
      mode = "x";
      key = "ys";
      action.__raw =
        # lua
        ''
          function()
            require('mini.surround').add('visual')
          end
        '';
    }
  ];
}
