{
  # Import all your configuration modules here
  imports = [
    ./plugins
  ];

  viAlias = true;
  vimAlias = true;
  withNodeJs = true;

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
    foldlevel = 99;
    fillchars = {
      foldopen = "";
      foldclose = "";
      fold = " ";
      foldsep = " ";
      diff = "╱";
      eob = " ";
    };
  };

  keymaps = [
    # Better up / down
    {
      mode = ["n" "x"];
      key = "j";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = ["n" "x"];
      key = "<Down>";
      action = "v:count == 0 ? 'gj' : 'j'";
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = ["n" "x"];
      key = "k";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
      };
    }
    {
      mode = ["n" "x"];
      key = "<Up>";
      action = "v:count == 0 ? 'gk' : 'k'";
      options = {
        expr = true;
        silent = true;
      };
    }

    # Move to window using the <ctrl> hjkl keys
    {
      mode = ["n"];
      key = "<C-h>";
      action = "<C-w>h";
      options = {
        desc = "Go to Left Window";
        remap = true;
      };
    }
    {
      mode = ["n"];
      key = "<C-j>";
      action = "<C-w>j";
      options = {
        desc = "Go to Lower Window";
        remap = true;
      };
    }
    {
      mode = ["n"];
      key = "<C-k>";
      action = "<C-w>k";
      options = {
        desc = "Go to Upper Window";
        remap = true;
      };
    }
    {
      mode = ["n"];
      key = "<C-l>";
      action = "<C-w>l";
      options = {
        desc = "Go to Right Window";
        remap = true;
      };
    }

    # Resize window using <ctrl> arrow keys
    {
      mode = ["n"];
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options = {desc = "Increase Window Height";};
    }
    {
      mode = ["n"];
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options = {desc = "Decrease Window Height";};
    }
    {
      mode = ["n"];
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options = {desc = "Decrease Window Width";};
    }
    {
      mode = ["n"];
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options = {desc = "Increase Window Width";};
    }

    # Move Lines
    {
      mode = ["n"];
      key = "<A-j>";
      action = "<cmd>m .+1<cr>==";
      options = {desc = "Move Down";};
    }
    {
      mode = ["n"];
      key = "<A-k>";
      action = "<cmd>m .-2<cr>==";
      options = {desc = "Move Up";};
    }
    {
      mode = ["i"];
      key = "<A-j>";
      action = "<esc><cmd>m .+1<cr>==gi";
      options = {desc = "Move Down";};
    }
    {
      mode = ["i"];
      key = "<A-k>";
      action = "<esc><cmd>m .-2<cr>==gi";
      options = {desc = "Move Up";};
    }
    {
      mode = ["v"];
      key = "<A-j>";
      action = ":m '>+1<cr>gv=gv";
      options = {desc = "Move Down";};
    }
    {
      mode = ["v"];
      key = "<A-k>";
      action = ":m '<-2<cr>gv=gv";
      options = {desc = "Move Up";};
    }

    # buffers
    {
      mode = ["n"];
      key = "<S-h>";
      action = "<cmd>bprevious<cr>";
      options = {desc = "Prev Buffer";};
    }
    {
      mode = ["n"];
      key = "<S-l>";
      action = "<cmd>bnext<cr>";
      options = {desc = "Next Buffer";};
    }
    {
      mode = ["n"];
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options = {desc = "Prev Buffer";};
    }
    {
      mode = ["n"];
      key = "]b";
      action = "<cmd>bnext<cr>";
      options = {desc = "Next Buffer";};
    }
    {
      mode = ["n"];
      key = "<leader>bb";
      action = "<cmd>e #<cr>";
      options = {desc = "Switch to Other Buffer";};
    }
    {
      mode = ["n"];
      key = "<leader>`";
      action = "<cmd>e #<cr>";
      options = {desc = "Switch to Other Buffer";};
    }
    # Clear search with <esc>
    {
      mode = ["i" "n"];
      key = "<esc>";
      action = "<cmd>noh<cr><esc>";
      options = {desc = "Escape and Clear hlsearch";};
    }

    # Clear search, diff update and redraw
    # taken from runtime/lua/_editor.lua
    {
      mode = ["n"];
      key = "<leader>ur";
      action = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>";
      options = {desc = "Redraw / Clear hlsearch / Diff Update";};
    }
    # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
    {
      mode = ["n"];
      key = "n";
      action = "'Nn'[v:searchforward].'zv'";
      options = {
        expr = true;
        desc = "Next Search Result";
      };
    }
    {
      mode = ["x"];
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next Search Result";
      };
    }
    {
      mode = ["o"];
      key = "n";
      action = "'Nn'[v:searchforward]";
      options = {
        expr = true;
        desc = "Next Search Result";
      };
    }
    {
      mode = ["n"];
      key = "N";
      action = "'nN'[v:searchforward].'zv'";
      options = {
        expr = true;
        desc = "Prev Search Result";
      };
    }
    {
      mode = ["x"];
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev Search Result";
      };
    }
    {
      mode = ["o"];
      key = "N";
      action = "'nN'[v:searchforward]";
      options = {
        expr = true;
        desc = "Prev Search Result";
      };
    }
    # Add undo break-points
    {
      mode = ["i"];
      key = ",";
      action = ",<c-g>u";
    }
    {
      mode = ["i"];
      key = ".";
      action = ".<c-g>u";
    }
    {
      mode = ["i"];
      key = ";";
      action = ";<c-g>u";
    }
    # save file
    {
      mode = ["i" "x" "n" "s"];
      key = "<C-s>";
      action = "<cmd>w<cr><esc>";
      options = {desc = "Save File";};
    }

    # keywordprg
    {
      mode = ["n"];
      key = "<leader>K";
      action = "<cmd>norm! K<cr>";
      options = {desc = "Keywordprg";};
    }

    # better indenting
    {
      mode = ["v"];
      key = "<";
      action = "<gv";
    }
    {
      mode = ["v"];
      key = ">";
      action = ">gv";
    }

    # lazy
    {
      mode = ["n"];
      key = "<leader>l";
      action = "<cmd>Lazy<cr>";
      options = {desc = "Lazy";};
    }

    # new file
    {
      mode = ["n"];
      key = "<leader>fn";
      action = "<cmd>enew<cr>";
      options = {desc = "New File";};
    }
    {
      mode = ["n"];
      key = "<leader>xl";
      action = "<cmd>lopen<cr>";
      options = {desc = "Location List";};
    }
    {
      mode = ["n"];
      key = "<leader>xq";
      action = "<cmd>copen<cr>";
      options = {desc = "Quickfix List";};
    }
    {
      mode = ["n"];
      key = "[q";
      action = "vim.cmd.cprev";
      lua = true;
      options = {desc = "Previous Quickfix";};
    }
    {
      mode = ["n"];
      key = "]q";
      action = "vim.cmd.cnext";
      lua = true;
      options = {desc = "Next Quickfix";};
    }
    # quit
    {
      mode = ["n"];
      key = "<leader>qq";
      action = "<cmd>qa<cr>";
      options = {desc = "Quit All";};
    }
    # highlights under cursor
    {
      mode = ["n"];
      key = "<leader>ui";
      action = "vim.show_pos";
      lua = true;
      options = {desc = "Inspect Pos";};
    }

    # windows
    {
      mode = ["n"];
      key = "<leader>ww";
      action = "<C-W>p";
      options = {
        desc = "Other Window";
        remap = true;
      };
    }
    {
      mode = ["n"];
      key = "<leader>wd";
      action = "<C-W>c";
      options = {
        desc = "Delete Window";
        remap = true;
      };
    }
    {
      mode = ["n"];
      key = "<leader>w-";
      action = "<C-W>s";
      options = {
        desc = "Split Window Below";
        remap = true;
      };
    }
    {
      mode = ["n"];
      key = "<leader>w|";
      action = "<C-W>v";
      options = {
        desc = "Split Window Right";
        remap = true;
      };
    }
    {
      mode = ["n"];
      key = "<leader>-";
      action = "<C-W>s";
      options = {
        desc = "Split Window Below";
        remap = true;
      };
    }
    {
      mode = ["n"];
      key = "<leader>|";
      action = "<C-W>v";
      options = {
        desc = "Split Window Right";
        remap = true;
      };
    }

    # tabs
    {
      mode = ["n"];
      key = "<leader><tab>l";
      action = "<cmd>tablast<cr>";
      options = {desc = "Last Tab";};
    }
    {
      mode = ["n"];
      key = "<leader><tab>f";
      action = "<cmd>tabfirst<cr>";
      options = {desc = "First Tab";};
    }
    {
      mode = ["n"];
      key = "<leader><tab><tab>";
      action = "<cmd>tabnew<cr>";
      options = {desc = "New Tab";};
    }
    {
      mode = ["n"];
      key = "<leader><tab>]";
      action = "<cmd>tabnext<cr>";
      options = {desc = "Next Tab";};
    }
    {
      mode = ["n"];
      key = "<leader><tab>d";
      action = "<cmd>tabclose<cr>";
      options = {desc = "Close Tab";};
    }
    {
      mode = ["n"];
      key = "<leader><tab>[";
      action = "<cmd>tabprevious<cr>";
      options = {desc = "Previous Tab";};
    }
  ];
  autoCmd = [
    # Highlight on yank
    {
      event = "TextYankPost";
      group = "highlight_yank";
      callback = {
        __raw =
          # lua
          ''
            function()
              vim.highlight.on_yank()
            end
          '';
      };
    }
    # resize splits if window got resized
    {
      event = "VimResized";
      group = "resize_splits";
      callback = {
        __raw =
          # lua
          ''
            function()
              local current_tab = vim.fn.tabpagenr()
              vim.cmd("tabdo wincmd =")
              vim.cmd("tabnext " .. current_tab)
            end
          '';
      };
    }
    # close some filetypes with <q>
    {
      event = "FileType";
      group = "close_with_q";
      pattern = [
        "PlenaryTestPopup"
        "help"
        "lspinfo"
        "notify"
        "qf"
        "query"
        "spectre_panel"
        "startuptime"
        "tsplayground"
        "neotest-output"
        "checkhealth"
        "neotest-summary"
        "neotest-output-panel"
      ];
      callback = {
        __raw =
          # lua
          ''
            function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cml>close<cr>", { buffer = event.buf, silent = true })
            end
          '';
      };
    }
    # Fix conceallevel for json files
    {
      event = "FileType";
      group = "json_conceal";
      pattern = ["json" "jsonc" "json5"];
      callback = {
        __raw =
          # lua
          ''
            function()
              vim.opt_local.conceallevel = 0
            end
          '';
      };
    }
  ];

  autoGroups = {
    highlight_yank.clear = true;
    resize_splits.clear = true;
    close_with_q.clear = true;
    json_conceal.clear = true;
    auto_create_dir.clear = true;
  };

  editorconfig.enable = true;
}
