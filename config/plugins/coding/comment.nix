{
  plugins.comment = {
    enable = true;
    settings = {
      sticky = false;
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>#";
      action = "gcc";
      options = {
        remap = true;
        desc = "Comment line";
      };
    }
    {
      mode = "v";
      key = "#";
      action = "gb";
      options = {
        remap = true;
        desc = "Comment block";
      };
    }
  ];

  extraConfigLua =
    # lua
    ''
      local comment_ft = require("Comment.ft")
      comment_ft.set('lua', { '--%s', '--[[%s]]' })
    '';
}
