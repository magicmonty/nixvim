{
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
      indent = true;
      nixvimInjections = true;
      nixGrammars = true;
      incrementalSelection = {
        enable = true;
        keymaps = {
          initSelection = "<C-Space>";
          nodeIncremental = "<C-Space>";
          nodeDecremental = "<BS>";
        };
      };
    };

    rainbow-delimiters.enable = true;
  };
}
