{pkgs, ...}: {
  plugins = {
    windsurf-nvim = {
      enable = true;
      settings = {
        enable_chat = true;
      };
    };

    cmp.settings.sources = [
      {
        name = "windsurf";
        keywordLength = 5;
        priority = 100;
      }
    ];
  };
}
