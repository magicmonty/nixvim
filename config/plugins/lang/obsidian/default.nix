{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.obsidian = {
    enable = mkEnableOption "Obsidian";
    workspaces = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = with lib.types; maybeRaw str;
              description = "The name for this workspace";
            };

            path = mkOption {
              type = with lib.types; maybeRaw str;
              description = "The of the workspace.";
            };
          };
        }
      );
      default = [
        {
          name = "private";
          path = "~/Dokumente/Notes/";
        }
      ];
      description = ''
        A list of vault names and paths.
        Each path should be the path to the vault root.
        If you use the Obsidian app, the vault root is the parent directory of the `.obsidian`
        folder.
        You can also provide configuration overrides for each workspace through the `overrides`
        field.
      '';
    };
  };

  config = let
    inherit (config.sys.lang.obsidian) enable workspaces;
    first_workspace_path = (lib.lists.elemAt workspaces 0).path;
  in
    mkIf enable {
      keymaps = [
        {
          mode = "n";
          key = "<leader>oo";
          action = ":cd ${first_workspace_path}<cr>";
          options = {desc = "Change current directory to Obsidian root";};
        }
        {
          mode = "n";
          key = "<leader>on";
          action.__raw = ''
            function()
              vim.cmd.ObsidianNew()
              vim.api.nvim_buf_set_lines(0, 0, -1, false, {})
              vim.cmd.ObsidianTemplate("note")
              vim.cmd(":%s/^#\\s\\d\\+-\\(.\\+\\)/# \\1/g")
              vim.cmd("norm Gi")
            end
          '';
          options = {desc = "New Obsidian note";};
        }
        {
          mode = "n";
          key = "<leader>ot";
          action.__raw =
            # lua
            ''
              function()
                vim.cmd("norm gg")
                vim.cmd.ObsidianTemplate("note")
                vim.cmd(":%s/^#\\s\\d\\+-\\(.\\+\\)/# \\1/g")
              end
            '';
        }
        {
          mode = "n";
          key = "<leader>oi";
          action = ":ObsidianPasteImg<cr>";
        }
      ];

      plugins = {
        render-markdown = {
          enable = true;
          settings = {
            bullet = {
              enabled = true;
              icons = ["•" "◦" "▹" "▸"];
              left_pad = 0;
              right_pad = 1;
            };
            checkbox = {
              unchecked = {
                icon = "󰄱 ";
                highlight = "ObsidianTodo";
              };
              checked = {
                icon = " ";
                highlight = "ObsidianDone";
              };
              custom = {
                rightArrow = {
                  raw = "[>]";
                  rendered = " ";
                  highlight = "ObsidianRightArrow";
                };
                tilde = {
                  raw = "[~]";
                  rendered = "󰰱 ";
                  highlight = "ObsidianTilde";
                };
                important = {
                  raw = "[!]";
                  rendered = " ";
                  highlight = "ObsidianImportant";
                };
              };
            };
          };
        };

        obsidian = {
          enable = true;
          settings = {
            inherit workspaces;

            notes_subdir = "inbox";
            new_notes_location = "notes_subdir";

            disable_frontmatter = true;

            templates = {
              subdir = "templates";
              date_format = "%Y-%m-%d";
              time_format = "%H:%M:%S";
            };

            completion = {
              nvim_cmp = true;
              min_chars = 2;
            };

            follow_url_func =
              # lua
              ''
                function(url)
                  vim.ui.open(url)
                end
              '';

            follow_img_func.__raw =
              # lua
              ''
                function(img)
                  vim.fn.jobstart({"xdg-open", img})
                end
              '';

            note_id_func =
              # lua
              ''
                function(title)
                  -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
                  -- In this case a note with the title 'My new note' will be given an ID that looks
                  -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
                  local suffix = ""
                  if title ~= nil then
                    -- If title is given, transform it into valid file name.
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                  else
                    -- If title is nil, just add 4 random uppercase letters to the suffix.
                    for _ = 1, 4 do
                      suffix = suffix .. string.char(math.random(65, 90))
                    end
                  end

                  return tostring(os.time()) .. "-" .. suffix
                end
              '';

            attachments = {
              confirm_img_paste = false;
              img_name_func.__raw =
                # lua
                ''
                  function()
                    -- Prefix image names with timestamp.
                    return string.format("pasted_img_%s", os.date "%Y%m%d%H%M%S")
                  end
                '';
              img_text_func =
                # lua
                ''
                  function(client, path)
                    ---@type string
                    local link_path
                    local vault_relative_path = client:vault_relative_path(path)
                    print(tostring(path))
                    print(tostring(vault_relative_path))
                    if vault_relative_path ~= nil then
                      -- Use relative path if the image is saved in the vault dir.
                      link_path = tostring(vault_relative_path)
                    else
                      -- Otherwise use the absolute path.
                      link_path = tostring(path)
                    end
                    local display_name = vim.fs.basename(link_path)
                    return string.format("![%s](%s)", display_name, link_path)
                  end
                '';
            };

            ui = {
              checkboxes = {
                " " = {
                  char = "󰄱 ";
                  hl_group = "ObsidianTodo";
                };
                "x" = {
                  char = " ";
                  hl_group = "ObsidianDone";
                };
                ">" = {
                  char = " ";
                  hl_group = "ObsidianRightArrow";
                };
                "~" = {
                  char = "󰰱 ";
                  hl_group = "ObsidianTilde";
                };
                "!" = {
                  char = " ";
                  hl_group = "ObsidianImportant";
                };
              };
              bullets = {
                char = "•";
                hl_group = "ObsidianBullet";
              };
              external_link_icon = {
                char = "  ";
                hl_group = "ObsidianExtLinkIcon";
              };
            };
          };
        };
      };
    };
}
