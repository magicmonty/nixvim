{
  plugins.treesitter-textobjects = {
    enable = true;
    lspInterop = {
      enable = true;
      border = "rounded";
    };
    move = {
      enable = true;
      gotoNextStart = {
        "äf" = {
          query = "@function.outer";
          desc = "Goto start of next function";
        };
        "äc" = {
          query = "@class.outer";
          desc = "Goto start of next class";
        };
      };
      gotoNextEnd = {
        "äF" = {
          query = "@function.outer";
          desc = "Goto end of next function";
        };
        "äC" = {
          query = "@class.outer";
          desc = "Goto end of next class";
        };
      };
      gotoPreviousStart = {
        "öf" = {
          query = "@function.outer";
          desc = "Goto start of previous function";
        };
        "öc" = {
          query = "@class.outer";
          desc = "Goto start of previous class";
        };
      };
      gotoPreviousEnd = {
        "öF" = {
          query = "@function.outer";
          desc = "Goto end of previous function";
        };
        "öC" = {
          query = "@class.outer";
          desc = "Goto end of previous class";
        };
      };
    };
  };

  extraConfigLuaPost =
    # lua
    ''
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    '';
}
