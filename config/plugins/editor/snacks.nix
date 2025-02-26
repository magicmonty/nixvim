{pkgs, ...}: {
  plugins.snacks = {
    enable = false;
  };

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "snacks.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "snacks.nvim";
        rev = "fa29c6c92631026a7ee41249c78bd91562e67a09";
        hash = "sha256-JiCgRLcikScrLgiw2PDeR806JKaQdvh4BzInA2pnmWY=";
      };
      doCheck = false;
    })
  ];

  extraConfigLua = ''
    require("snacks").setup {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      image = {
        enabled = true,
        doc = {
          conceal = true
        },
        convert = {
          notify = false
        }
      },

      notifier = {
        enabled = true,
        style = "fancy"
      }
    }
  '';
}
