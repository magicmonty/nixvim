{
  config,
  pkgs,
  lib,
  helpers,
  ...
}: {
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "tailwindcss-colorizer-cmp";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "roobert";
        repo = "tailwindcss-colorizer-cmp.nvim";
        rev = "3d3cd95e4a4135c250faf83dd5ed61b8e5502b86";
        hash = "sha256-PIkfJzLt001TojAnE/rdRhgVEwSvCvUJm/vNPLSWjpY=";
      };
    })
  ];

  extraConfigLua = ''
    require("tailwindcss-colorizer-cmp").setup({
        color_square_width = 2;
      })
  '';

  plugins.cmp.settings.formatting.format = let
    cfg = config.plugins.lspkind;
    options = {
      mode = cfg.settings.mode or "symbol";
      maxwidth = {
        menu = 50;
        abbr = 50;
      };
      ellipsis_char = "…";
      show_labelDetails = false;
    };
  in
    lib.mkForce
    # lua
    ''
      function(entry, vim_item)
        local kind = require('lspkind').cmp_format(${helpers.toLuaObject options})(entry, vim_item)

        return require('tailwindcss-colorizer-cmp').formatter(entry, vim_item)
      end
    '';
}
