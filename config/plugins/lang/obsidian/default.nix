{
  config,
  lib,
  helpers,
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
          path = "~/Dokumente/Notes/private";
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
  in
    mkIf enable {
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
          };
        };

        obsidian = {
          enable = true;
          settings = {
            inherit workspaces;

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

            follow_img_func =
              # lua
              ''
                function(img)
                  vim.fn.jobstart({"xdg-open", url})
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

            ui = {
              checkboxes = {
                " " = {
                  char = "☐";
                  hl_group = "ObsidianTodo";
                };
                "x" = {
                  char = "";
                  hl_group = "ObsidianDone";
                };
                ">" = {
                  char = "";
                  hl_group = "ObsidianRightArrow";
                };
                "~" = {
                  char = "󰰱";
                  hl_group = "ObsidianTilde";
                };
                "!" = {
                  char = "";
                  hl_group = "ObsidianImportant";
                };
              };
              bullets = {
                char = "•";
                hl_group = "ObsidianBullet";
              };
              external_link_icon = {
                char = "";
                hl_group = "ObsidianExtLinkIcon";
              };
            };
          };
        };
      };
    };
}
