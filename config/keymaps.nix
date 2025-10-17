{
  keymaps = let
    kmap = mode: key: action: options: {
      inherit mode;
      inherit key;
      inherit action;
      inherit options;
    };
    nremap = key: action: desc: (kmap "n" key action {
      inherit desc;
      remap = true;
      silent = true;
    });
    lmap = mode: key: action: options: {
      inherit mode;
      inherit key;
      action.__raw = action;
      inherit options;
    };
    lnremap = key: action: desc: (lmap "n" key action {
      inherit desc;
      remap = true;
      silent = true;
    });
  in [
    # Better up / down
    (kmap ["n" "x"] "j" "v:count == 0 ? 'gj' : 'j'" {
      expr = true;
      silent = true;
    })
    (kmap ["n" "x"] "<Down>" "v:count == 0 ? 'gj' : 'j'" {
      expr = true;
      silent = true;
    })
    (kmap ["n" "x"] "k" "v:count == 0 ? 'gk' : 'k'" {
      expr = true;
      silent = true;
    })
    (kmap ["n" "x"] "<Up>" "v:count == 0 ? 'gk' : 'k'" {
      expr = true;
      silent = true;
    })

    # Move to window using the <ctrl> hjkl keys
    (nremap "<C-h>" "<C-w>h" "Go to left window")
    (nremap "<C-j>" "<C-w>j" "Go to lower window")
    (nremap "<C-k>" "<C-w>k" "Go to upper window")
    (nremap "<C-l>" "<C-w>l" "Go to right window")

    # Resize window using <ctrl> arrow keys
    (kmap "n" "<C-Up>" "<cmd>resize +2<cr>" {desc = "Increase window height";})
    (kmap "n" "<C-Down>" "<cmd>resize -2<cr>" {desc = "Decrease window height";})
    (kmap "n" "<C-Left>" "<cmd>vertical resize -2<cr>" {desc = "Decrease window width";})
    (kmap "n" "<C-Right>" "<cmd>vertical resize +2<cr>" {desc = "Increase window width";})

    # Move Lines
    (kmap "n" "<A-j>" "<cmd>m .+1<cr>==" {desc = "Move Down";})
    (kmap "n" "<C-S-Down>" "<cmd>m .+1<cr>==" {desc = "Move Down";})
    (kmap "n" "<A-k>" "<cmd>m .-2<cr>==" {desc = "Move Up";})
    (kmap "n" "<C-S-Up>" "<cmd>m .-2<cr>==" {desc = "Move Up";})
    (kmap "i" "<A-j>" "<esc><cmd>m .+1<cr>==gi" {desc = "Move Down";})
    (kmap "i" "<C-S-Down>" "<esc><cmd>m .+1<cr>==gi" {desc = "Move Down";})
    (kmap "i" "<A-k>" "<esc><cmd>m .-2<cr>==gi" {desc = "Move Up";})
    (kmap "i" "<C-S-Up>" "<esc><cmd>m .-2<cr>==gi" {desc = "Move Up";})
    (kmap "v" "<A-j>" "<cmd>m '>+1<cr>gv=gv" {desc = "Move Down";})
    (kmap "v" "<C-S-Down>" "<cmd>m '>+1<cr>gv=gv" {desc = "Move Down";})
    (kmap "v" "<A-k>" "<cmd>m '<-2<cr>gv=gv" {desc = "Move Up";})
    (kmap "v" "<C-S-Up>" "<cmd>m '<-2<cr>gv=gv" {desc = "Move Up";})

    # buffers
    (kmap "n" "<S-h>" "<cmd>bprevious<cr>" {
      desc = "Prev Buffer";
      silent = true;
      remap = true;
    })
    (kmap "n" "<leader>bp" "<cmd>bprevious<cr>" {
      desc = "Prev Buffer";
      silent = true;
      remap = true;
    })
    (kmap "n" "öb" "<cmd>bprevious<cr>" {
      desc = "Prev Buffer";
      silent = true;
      remap = true;
    })

    (kmap "n" "<S-l>" "<cmd>bnext<cr>" {
      desc = "Next Buffer";
      silent = true;
      remap = true;
    })
    (kmap "n" "<leader>bn" "<cmd>bnext<cr>" {
      desc = "Next Buffer";
      silent = true;
      remap = true;
    })
    (kmap "n" "äb" "<cmd>bnext<cr>" {
      desc = "Next Buffer";
      silent = true;
      remap = true;
    })
    (nremap "<leader>," "<cmd>e #<cr>" "Switch to other buffer")
    (nremap "<leader>bb" "<cmd>e #<cr>" "Switch to other buffer")
    (nremap "<leader>ai" "<cmd>CopilotChat<cr>" "Open Copilot Chat")
    {
      key = "<leader>bd";
      action.__raw =
        # lua
        ''
          function()
            local bd = require("mini.bufremove").delete
            if vim.bo.modified then
              local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
              if choice == 1 then -- Yes
                vim.cmd.write()
                bd(0)
              elseif choice == 2 then -- No
                bd(0, true)
              end
            else
              bd(0)
            end
          end
        '';
      options = {
        desc = "Delete Buffer";
      };
    }
    (lnremap "<leader>bD" "function() require('mini.bufremove').delete(0, true) end" "Delete Buffer (Force)")

    # Clear search with <esc>
    (kmap ["i" "n"] "<esc>" "<cmd>noh<cr><esc>" {desc = "Escape and Clear hlsearch";})

    # Clear search, diff update and redraw
    # taken from runtime/lua/_editor.lua
    (nremap "<leader>ur" "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>" "Redraw / Clear hlsearch / Diff Update")

    # https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
    (kmap "n" "n" "'Nn'[v:searchforward].'zv'" {
      expr = true;
      desc = "Next Search Result";
    })
    (kmap ["x" "o"] "n" "'Nn'[v:searchforward]" {
      expr = true;
      desc = "Next Search Result";
    })
    (kmap "n" "N" "'nN'[v:searchforward].'zv'" {
      expr = true;
      desc = "Prev Search Result";
    })
    (kmap ["x" "o"] "N" "'nN'[v:searchforward]" {
      expr = true;
      desc = "Prev Search Result";
    })

    # Add undo break-points
    (kmap "i" "," ",<c-g>u" {})
    (kmap "i" ";" ";<c-g>u" {})

    # save file
    (kmap ["i" "x" "n" "s"] "<C-s>" "<cmd>w<cr><esc>" {desc = "Save File";})

    # better indenting
    (kmap ["v" "x"] "<" "<gv" {desc = "Indent Left";})
    (kmap ["v" "x"] ">" ">gv" {desc = "Indent Right";})

    # new file
    (nremap "<leader>fn" "<cmd>enew<cr>" "New File")
    (nremap "<leader>xl" "<cmd>lopen<cr>" "Location List")
    (nremap "<leader>xq" "<cmd>copen<cr>" "Quickfix List")
    (lnremap "öq" "vim.cmd.cprev" "Previous Quickfix")
    (lnremap "äq" "vim.cmd.cnext" "Next Quickfix")

    # quit
    (nremap "<leader>qq" "<cmd>qa<cr>" "Quit All")

    # highlights under cursor
    (lnremap "<leader>ui" "vim.show_pos" "Inspect Pos")

    # windows
    (nremap "<leader>ww" "<C-W>p" "Other Window")
    (nremap "<leader>wd" "<C-W>c" "Delete Window")
    (nremap "<leader>w-" "<C-W>s" "Split Window Below")
    (nremap "<leader>-" "<C-W>s" "Split Window Below")
    (nremap "<leader>w#" "<C-W>v" "Split Window Right")
    (nremap "<leader>#" "<C-W>v" "Split Window Right")

    # tabs
    (nremap "<leader><tab>l" "<cmd>tablast<cr>" "Last Tab")
    (nremap "<leader><tab>f" "<cmd>tabfirst<cr>" "First Tab")
    (nremap "<leader><tab><tab>" "<cmd>tabnew<cr>" "New Tab")
    (kmap "n" "<leader><tab>ö" "<cmd>tabprevious<cr>" {desc = "Previous tab";})
    (kmap "n" "<leader><tab>ä" "<cmd>tabnext<cr>" {desc = "Next tab";})
    (kmap "n" "<leader><tab>d" "<cmd>tabclose<cr>" {desc = "Close Tab";})

    # Checkbox
    (nremap "<leader>tz" ":s/\\[\\s\\?\\]/[x]/<cr>" "Check checkbox")
    (nremap "<leader>tu" ":s/\\[[x~>!]\\]/[ ]/<cr>" "Uncheck checkbox")
  ];

  extraConfigLua =
    # lua
    ''
      local map = vim.keymap.set
      local diagnostic_goto = function(next, severity)
        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
        severity = severity and vim.diagnostic.severity[severity] or nil
        return function()
          go({ severity = severity, border = "rounded" })
        end
      end

      -- ignore capitalization mistakes
      vim.cmd("ca W w")
      vim.cmd("ca Q q")
      vim.cmd("ca WQ wq")
      vim.cmd("ca Wq wq")

      map("n", "äd", diagnostic_goto(true), { desc = "Next diagnostic", remap = true, silent = true })
      map("n", "öd", diagnostic_goto(false), { desc = "Previous diagnostic", remap = true, silent = true })
      map("n", "äe", diagnostic_goto(true, "ERROR"), { desc = "Previous error", remap = true, silent = true })
      map("n", "öe", diagnostic_goto(false, "ERROR"), { desc = "Previous error", remap = true, silent = true })
      map("n", "äw", diagnostic_goto(true, "WARN"), { desc = "Previous warning", remap = true, silent = true })
      map("n", "öw", diagnostic_goto(false, "WARN"), { desc = "Previous warning", remap = true, silent = true })

      vim.keymap.del('i', '<Tab>');
      vim.keymap.del({'n', 'x'}, 's')

      map( "i", "<Tab>", function()
          local luasnip = require("luasnip")
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            if vim.bo.filetype == "markdown" then
              pcall(vim.cmd.MkdnTableNextCell)
            end
          end

        end,
        { desc = "Expand Snippet or Jump to Next Cell", remap = true, silent = true }
      );
    '';
}
