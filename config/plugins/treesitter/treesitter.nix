{
  plugins = {
    treesitter = {
      enable = true;
      folding = true;
      nixGrammars = true;
      nixvimInjections = true;
      settings = {
        indent.enable = true;
        highlight.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-V>";
            node_decremental = "<BS>";
            node_incremental = "<C-V>";
          };
        };
      };
    };

    rainbow-delimiters.enable = true;
  };
}
