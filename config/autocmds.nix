{
  config = {
    autoCmd = [
      {
        event = "TermClose";
        pattern = "*lazygit";
        callback = {
          __raw =
            # lua
            ''
              function()
                if package.loaded["neo-tree.sources.git_status"] then
                  require("neo-tree.sources.git_status").refresh()
                end
              end
            '';
        };
      }
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
      # Fix conceallevel for markdown files
      {
        event = "FileType";
        group = "markdown_conceal";
        pattern = ["markdown"];
        callback = {
          __raw =
            # lua
            ''
              function()
                vim.opt_local.conceallevel = 2
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
  };
}
