{
  plugins.mini.modules.ai = {
    n_lines = 500;
    mappings = {
      goto_left = "gö";
      goto_right = "gä";
    };
    custom_textobjects = {
      o = {
        __raw = ''
          require('mini.ai').gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {})
        '';
      };
      f = {__raw = "require('mini.ai').gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {})";};
      c = {__raw = "require('mini.ai').gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {})";};
      t = [
        "<([%p%w]-)%f[^<%w][^<>]->.-</%1>"
        "^<.->().*()</[^/]->$"
      ];
      d = ["%f[%d]%d+"]; # Digits
      e = [
        # word with case
        [
          "%u[%l%d]+%f[^%l%d]"
          "%f[%S][%l%d]+%f[^%l%d]"
          "%f[%P][%l%d]+%f[^%l%d]"
          "^[%l%d]+%f[^%l%d]"
        ]
        "^().*()$"
      ];
      g = {
        __raw =
          # lua
          ''
            function() -- Whole buffer, similar to `gg` and 'G' motion
              local from = { line = 1, col = 1 }
              local to = {
                line = vim.fn.line("$"),
                col = math.max(vim.fn.getline("$"):len(), 1),
              }
              return { from = from, to = to }
            end
          '';
      };
      u = {__raw = "require('mini.ai').gen_spec.function_call()";}; # u for "Usage"
      U = {__raw = "require('mini.ai').gen_spec.function_call({ name_pattern = '[%w_]' })";}; # without dot in function name
    };
  };
}
