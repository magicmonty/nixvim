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

    treesitter-context = {
      enable = true;
      settings = {
        line_numbers = true;
        max_lines = 3;
        mode = "cursor";
        multiline_threshold = 20;
        separator = "-";
        trim_scope = "inner";
        zindex = 20;
      };
    };

    treesitter-refactor = {
      enable = true;
      highlightCurrentScope.enable = false;
      highlightDefinitions.enable = true;
      navigation = {
        enable = true;
        keymaps = {
          gotoDefinition = "gd";
        };
      };
      smartRename = {
        enable = true;
        keymaps.smartRename = "<leader>rr";
      };
    };

    treesitter-textobjects = {
      enable = true;
      lspInterop = {
        enable = true;
        border = "rounded";
      };
    };

    rainbow-delimiters.enable = true;
  };
}
