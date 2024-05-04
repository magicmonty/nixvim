{
  plugins.treesitter-context = {
    enable = true;
    settings = {
      line_numbers = true;
      max_lines = 3;
      mode = "cursor";
      multiline_threshold = 20;
      separator = "-";
      trim_scope = "inner";
      zindex = 20;
    };
  };

  keymaps = [
    {
      mode = "n";
      "key" = "<leader>ut";
      action =
        # lua
        ''
          function()
            local tsc = require("treesitter-context")
            tsc.toggle()
            if NixVim.inject.get_upvalue(tsc.toggle, "enabled") then
              NixVim.info("Enabled Treesitter Context", { title = "Option" })
            else
              NixVim.warn("Disabled Treesitter Context", { title = "Option" })
            end
          end
        '';
      lua = true;
      options = {desc = "Toggle Treesitter Context";};
    }
  ];
}
