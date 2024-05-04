{
  plugins.todo-comments = {
    enable = true;
  };

  keymaps = [
    {
      key = "ät";
      action = "function() require('todo-comments').jump_next() end";
      lua = true;
      options = {desc = "Next Todo Comment";};
    }
    {
      key = "öt";
      action = "function() require('todo-comments').jump_prev() end";
      lua = true;
      options = {desc = "Previous Todo Comment";};
    }
    {
      key = "<leader>xt";
      action = "<cmd>TodoTrouble<cr>";
      options = {desc = "Todo (Trouble)";};
    }
    {
      key = "<leader>xT";
      action = "<cmd>TodoTrouble keywords=TODO;FIX;FIXME<cr>";
      options = {desc = "Todo/Fix/Fixme (Trouble)";};
    }
    {
      key = "<leader>st";
      action = "<cmd>TodoTelescope<cr>";
      options = {desc = "Todo";};
    }
    {
      key = "<leader>sT";
      action = "<cmd>TodoTelescope keywords=TODO;FIX;FIXME<cr>";
      options = {desc = "Todo/Fix/Fixme";};
    }
  ];
}
