{
  plugins.markdown-preview = {
    enable = true;
  };

  autoCmd = [
    {
      event = "FileType";
      pattern = ["markdown"];
      callback = {
        __raw =
          # lua
          ''
            function()
              local bufnr = vim.api.nvim_get_current_buf()
              vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", { noremap = true, silent = true, desc = "Markdown Preview", buffer = bufnr })
            end
          '';
      };
    }
  ];
}
