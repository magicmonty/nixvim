{
  plugins.mini.modules.surround = {
    mappings = {
      add = "gsa";
      delete = "gsd";
      find = "gsf";
      find_left = "gsF";
      highlight = "gsh";
      replace = "gsr";
      update_n_lines = "gsn";
    };

    silent = true;
  };

  /*
     keymaps = [
    {
      mode = "x";
      key = "ys";
      action =
        # lua
        ''
          function()
            require('mini.surround').add('visual')
          end
        '';
      options = {silent = true;};
    }
  ];
  */
}
