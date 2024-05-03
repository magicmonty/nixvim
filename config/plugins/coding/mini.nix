{
  plugins.mini = {
    enable = true;
    modules = {
      surround = {
        mappings = {
          add = "ys";
          delete = "ds";
          find = "";
          find_left = "";
          highlight = "";
          replace = "cs";
          update_n_lines = "";
        };

        silent = true;
      };
    };
  };

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
}
