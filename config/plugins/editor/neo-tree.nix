{
  plugins.neo-tree = {
    enable = true;
    closeIfLastWindow = true;
    eventHandlers = {
      file_opened =
        # lua
        ''
          function()
            require('neo-tree.command').execute({ action = "close" })
          end
        '';
    };
    defaultComponentConfigs.gitStatus.symbols = {
      untracked = "★";
      unstaged = "✗";
      staged = "✓";
      ignored = "◌";
      deleted = "";
      renamed = "➜";
      conflict = "";
    };
  };
}
