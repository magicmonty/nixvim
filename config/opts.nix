{
  pkgs,
  lib,
  ...
}:
with lib; {
  options.nixvim.flavour = mkOption {
    description = "The flavour of this NixVim distribution (either lite or full)";
    type = types.enum ["lite" "full"];
    default = "full";
  };

  config = {
    extraPackages = with pkgs; [
      fd
      fzf
      gnused
      ripgrep
      unzip
    ];

    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    enableMan = false;
    editorconfig.enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = "\\";
      markdown_recommended_style = 0; # Fix markdown indentation settings
    };

    opts = {
      timeoutlen = 300; # lower than default (1000)  to quickly trigger which-key
      updatetime = 200; # faster completion (save swap file and trigger CursorHold)

      number = true; # print line numbers
      relativenumber = true; # relative line numbers

      clipboard = "unnamedplus";
      autoindent = true;
      expandtab = true; # use spaces instead of tabs
      tabstop = 2; # Number of spaces tabs count for
      smartindent = true; # Insert indents automatically
      shiftround = true; # Round indent
      shiftwidth = 2; # Size of an indent

      ignorecase = true; # Ignore case on search
      smartcase = true; # Except if the search term is written cased
      incsearch = true;
      inccommand = "nosplit"; # preview incremental substitutions
      wildmode = "longest:full,full"; # command line completion mode

      swapfile = false;
      undofile = true; # Build-in persistent undo
      undolevels = 10000;

      autowrite = true;

      completeopt = "menu,menuone,noselect";
      conceallevel = 2; # Hide * markup for bold and italic, but not markers with subsitutions
      confirm = true; # Confirm to save changes before exiting modified buffer;
      cursorline = true; # Enable highlighting of the current lines
      formatoptions = "jcroqlnt"; # tcqj
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      laststatus = 3; # global statusline
      list = true; # Show some invisible characters (tabs...)
      mouse = "a"; # enable mouse mode

      pumblend = 10; # Popup blend
      pumheight = 10; # maximum number of entries in a popup
      scrolloff = 4; # lines of context
      sidescrolloff = 8; # columns of context
      sessionoptions = ["buffers" "curdir" "tabpages" "winsize" "help" "globals" "skiprtp" "folds"];
      showmode = false; # Don't show mode since we have a statusline
      signcolumn = "yes"; # Always show the signcolumn, otherwise it would shift the text each time
      splitbelow = true; # put new windows below current
      splitright = true; # put new windows right of current
      splitkeep = "screen";
      termguicolors = true; # True color support
      virtualedit = "block"; # Allow cursor to move where there is no text in visual block mode
      winminwidth = 5; # Minimum window width
      wrap = false; # Disable line wrap
      fillchars = {
        foldopen = "";
        foldclose = "";
        fold = " ";
        foldsep = " ";
        diff = "╱";
        eob = " ";
      };

      # set encoding type
      encoding = "utf-8";
      fileencoding = "utf-8";
      cmdheight = 0; # Height of the command bar
    };

    extraConfigLuaPre =
      # lua
      ''
        P = function(v)
          print(vim.inspect(v))
          return v
        end

        DN = function(v)
          local time = os.date('%H:%M')
          local msg = time
          vim.notify(vim.inspect(v), 'debug', { title = { 'Debug Output', msg } })
          return v
        end
      '';
  };
}
