{pkgs, ...}: {
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
  extraConfigLuaPost = ''
    cmp.config.formatting = {
      format = require("tailwindcss-colorizer-cmp").formatter
    }
  '';
}
