{
  plugins.nvim-autopairs = {
    enable = true;
    settings = {
      disable_filetype = [
        "TelescopePrompt"
        "dashboard"
      ];
      check_ts = true;
      ts_config = {
        lua = ["string"];
      };
      enable_check_bracket_line = true;
    };
  };
}
