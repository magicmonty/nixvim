{
  plugins = {
    codeium-nvim = {
      enable = true;
      extraOptions = {
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
