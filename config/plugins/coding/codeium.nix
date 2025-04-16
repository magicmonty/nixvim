{pkgs, ...}: {
  plugins = {
    codeium-nvim = {
      enable = true;
      settings = {
        enable_chat = true;
      };
      package = pkgs.vimPlugins.windsurf-nvim;
    };

    cmp.settings.sources = [
      {
        name = "codeium";
        keywordLength = 5;
        priority = 100;
      }
    ];
  };
}
