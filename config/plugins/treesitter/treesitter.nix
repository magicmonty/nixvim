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
          initSelection = "<C-V>";
          nodeIncremental = "<C-V>";
          nodeDecremental = "<BS>";
        };
      };
    };

    rainbow-delimiters.enable = true;
  };
}
