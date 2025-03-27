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
        rev = "bc0630e43be5699bb94dadc302c0d21615421d93";
        hash = "sha256-Gw0Bp2YeoESiBLs3NPnqke3xwEjuiQDDU1CPofrhtig="; # lib.fakeHash;
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
