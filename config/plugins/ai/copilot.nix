{pkgs, ...}: {
  extraPackages = with pkgs; [
    lynx
    lsof
  ];
  keymaps = [
    {
      mode = "n";
      key = "<leader>ai";
      action = "<cmd>CopilotChatToggle<CR>";
      options = {
        noremap = true;
        silent = true;
      };
    }
    {
      key = "<leader>ao";
      mode = ["n" "x"];
      action.__raw = ''
        function()
          require("snacks.terminal").toggle("opencode --port", { win = { position = "right", enter = false } })
        end
      '';
      options = {desc = "Toggle OpenCode…";};
    }
    {
      key = "<leader>aa";
      mode = ["n" "x"];
      action.__raw = ''
        function()
          require("opencode").ask("@this: ")
        end
      '';
      options = {desc = "Ask OpenCode…";};
    }
    {
      key = "<leader>as";
      mode = ["n" "x"];
      action.__raw = ''
        function()
          require("opencode").select()
        end
      '';
      options = {desc = "Select OpenCode…";};
    }
    {
      key = "go";
      mode = ["n" "x"];
      action.__raw = ''
        function()
          return require("opencode").operator("@this ")
        end
      '';
      options = {
        desc = "Append range to OpenCode";
        expr = true;
      };
    }
    {
      key = "goo";
      mode = ["n"];
      action.__raw = ''
        function()
          return require("opencode").operator("@this ") .. "_"
        end
      '';
      options = {
        desc = "Append line to OpenCode";
        expr = true;
      };
    }
    {
      key = "<S-C-u>";
      mode = ["n"];
      action.__raw = ''
        function()
          require("opencode").command("session.half.page.up")
        end
      '';
      options = {desc = "OpenCode: Scroll up";};
    }
    {
      key = "<S-C-d>";
      mode = ["n"];
      action.__raw = ''
        function()
          require("opencode").command("session.half.page.down")
        end
      '';
      options = {desc = "OpenCode: Scroll down";};
    }
  ];

  plugins = {
    snacks = {
      settings = {
        picker = {
          actions = {
            opencode_send.__raw = ''
              function(picker)
                local items = vim.tbl_map(
                  function(item)
                    return item.file
                      and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                      or item.text
                  end,
                  picker:selected({ fallback = true })
                )

                require("opencode").prompt(table.concat(items, ", ") .. " ")
              end
            '';
          };
          win = {
            input = {
              keys = {
                "<a-a>" = {
                  __unkeyed-1 = "opencode_send";
                  mode = ["n" "i"];
                };
              };
            };
          };
        };
      };
    };

    blink-cmp.settings.sources = {
      default = [
        "lsp"
        "path"
        "snippets"
        "emoji"
        "buffer"
        "copilot"
      ];

      providers = {
        copilot = {
          async = true;
          module = "blink-copilot";
          name = "copilot";
          score_offset = 100;
          opts = {
            max_completions = 3;
            max_attempts = 4;
            kind = "Copilot";
            debounce = 750;
            auto_refresh = {
              backward = true;
              forward = true;
            };
          };
        };
      };
    };

    copilot-chat = {
      enable = true;
      settings = {
        debug = true;
        show_help = true;
        model = "claude-opus-4.6";
        window = {
          layout = "float";
        };
        auto_follow_cursor = false;
      };
    };

    opencode = {
      enable = true;
      settings = {
        server = {
          url = "http://localhost:4096";
          start.__raw = ''
            function()
              require("snacks.terminal").open("opencode -port", { win = { position = "right", enter = false } })
            end
          '';
        };
      };
    };

    copilot-lua = {
      enable = true;

      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
        filetypes = {
          "." = false;
          gitcommit = false;
          gitrebase = false;
          help = false;
          markdown = true;
          yaml = true;
        };
      };

      luaConfig.post =
        # lua
        ''
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        '';
    };
  };
}
