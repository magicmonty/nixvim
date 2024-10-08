_: {
  plugins = {
    friendly-snippets.enable = true;

    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      # Triggers the load of friendly-snippets
      fromVscode = [{}];
      fromLua = [
        {
          lazyLoad = true;
          paths = ./snippets;
        }
      ];
    };
  };
}
