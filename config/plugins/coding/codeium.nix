{
  plugins = {
    codeium-nvim = {
      enable = true;
      settings = {
        enable_chat = true;
      };
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
