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
      extraConfigLuaPre = ''
        function find_assets_dir()
          local dir = vim.fn.expand("%:p:h")
          while dir ~= "/" do
            local full_path = dir .. "/assets"
            if vim.fn.isdirectory(full_path) == 1 then
              return full_path
            end
            dir = vim.fn.fnamemodify(dir, ":h")
          end
          return nil
        end
        function get_image_path()
          -- Get the current line
          local line = vim.api.nvim_get_current_line()
          -- Pattern to match image path in Markdown
          local image_pattern = "%[.-%]%((.-)%)"
          -- Extract relative image path
          local _, _, image_path = string.find(line, image_pattern)
          return image_path
        end
        function get_absolute_image_path(image_path)
          -- Check if the image path is relative or absolute
          if string.sub(image_path, 1, 1) == "/" then
            -- Absolute path
            if vim.fn.filereadable(image_path) == 0 then
              return nil
            else
              return image_path
            end
          else
            -- Relative path
            local IMAGES_DIR = "imgs/"

            local assets_dir = find_assets_dir()
            if assets_dir then
              -- if image_path starts with "assets/" trim "assets/" from the beginning
              if string.sub(image_path, 1, 7) == "assets/" then
                image_path = string.sub(image_path, 8)
              end

              -- try to find in assets/imgs/ directory, when the image path starts with "imgs/"
              if string.sub(image_path, 1, 5) == IMAGES_DIR then
                local absolute_image_path = assets_dir .. "/" .. image_path
                if vim.fn.filereadable(absolute_image_path) == 1 then
                  return absolute_image_path
                end
              else
                -- check if the image is directly in the assets directory
                local absolute_image_path = assets_dir .. "/" .. image_path
                if vim.fn.filereadable(absolute_image_path) == 0 then
                  -- otherwise check if the image is in the assets/imgs directory
                  absolute_image_path = assets_dir .. "/" .. IMAGES_DIR .. image_path
                  if vim.fn.filereadable(absolute_image_path) == 1 then
                    return absolute_image_path
                  end
                else
                  return absolute_image_path
                end
              end
            end

            -- if not found yet construct absolute path from current file path
            local current_file_path = vim.fn.expand("%:p:h")
            local absolute_image_path = current_file_path .. "/" .. image_path

            if vim.fn.filereadable(absolute_image_path) == 0 then
              return nil
            else
              return absolute_image_path
            end
          end
        end
      '';
      keymaps = [
        {
          mode = "n";
          key = "<leader>ir";
          action.__raw = ''
            function()
              -- Get the image path
              local image_path = get_image_path()

              if not image_path then
                vim.api.nvim_echo({ { "No image found under the cursor", "WarningMsg" } }, false, {})
                return
              end

              -- Check if it's a URL
              if string.sub(image_path, 1, 4) == "http" then
                vim.api.nvim_echo({ { "URL images cannot be renamed.", "WarningMsg" } }, false, {})
                return
              end

              -- Get absolute path
              local absolute_image_path = get_absolute_image_path(image_path)

              -- Check if file exists
              if absolute_image_path == nil then
                vim.api.nvim_echo(
                  { { "Image file does not exist:\n", "ErrorMsg" }, { absolute_image_path, "ErrorMsg" } },
                  false,
                  {}
                )
                return
              end

              -- Get directory and extension of current image
              local dir = vim.fn.fnamemodify(absolute_image_path, ":h")
              local ext = vim.fn.fnamemodify(absolute_image_path, ":e")
              local current_name = vim.fn.fnamemodify(absolute_image_path, ":t:r")
              -- Prompt for new name
              vim.ui.input({ prompt = "Enter new name (without extension): ", default = current_name }, function(new_name)
                if not new_name or new_name == "" then
                  vim.api.nvim_echo({ { "Rename cancelled", "WarningMsg" } }, false, {})
                  return
                end
                -- Construct new path
                local new_absolute_path = dir .. "/" .. new_name .. "." .. ext
                -- Check if new filename already exists
                if vim.fn.filereadable(new_absolute_path) == 1 then
                  vim.api.nvim_echo({ { "File already exists: " .. new_absolute_path, "ErrorMsg" } }, false, {})
                  return
                end
                -- Rename the file
                local success, err = os.rename(absolute_image_path, new_absolute_path)
                if success then
                  -- Get the old and new filenames (without path)
                  local old_filename = vim.fn.fnamemodify(absolute_image_path, ":t")
                  local new_filename = vim.fn.fnamemodify(new_absolute_path, ":t")
                  -- -- Debug prints
                  -- print("Old filename:", old_filename)
                  -- print("New filename:", new_filename)
                  -- Get buffer content
                  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                  -- print("Number of lines in buffer:", #lines)
                  -- Replace the text in each line that contains the old filename
                  for i = 0, #lines - 1 do
                    local line = lines[i + 1]
                    -- First find the image markdown pattern with explicit end
                    local img_start, img_end = line:find("!%[.-%]%(.-%)")
                    if img_start and img_end then
                      -- Get just the exact markdown part without any extras
                      local markdown_part = line:match("!%[.-%]%(.-%)")
                      -- Replace old filename with new filename
                      local escaped_old = old_filename:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1")
                      local escaped_new = new_filename:gsub("[%%]", "%%%%")
                      -- Replace in the exact markdown part
                      local new_markdown = markdown_part:gsub(escaped_old, escaped_new)
                      -- Replace that exact portion in the line
                      vim.api.nvim_buf_set_text(
                        0,
                        i,
                        img_start - 1,
                        i,
                        img_start + #markdown_part - 1, -- Use exact length of markdown part
                        { new_markdown }
                      )
                    end
                  end
                  -- "Update" saves only if the buffer has been modified since the last save
                  vim.cmd("update")
                  vim.api.nvim_echo({
                    { "Image renamed successfully", "Normal" },
                  }, false, {})
                else
                  vim.api.nvim_echo({
                    { "Failed to rename image:\n", "ErrorMsg" },
                    { tostring(err), "ErrorMsg" },
                  }, false, {})
                end
              end)
            end
          '';
          options = {desc = "Rename image file";};
        }
        {
          mode = "n";
          key = "<leader>id";
          action.__raw = ''
            function()
              local image_path = get_image_path()
              if not image_path then
                vim.api.nvim_echo({ { "No image found under the cursor", "WarningMsg" } }, false, {})
                return
              end
              if string.sub(image_path, 1, 4) == "http" then
                vim.api.nvim_echo({ { "URL image cannot be deleted from disk.", "WarningMsg" } }, false, {})
                return
              end
              local absolute_image_path = get_absolute_image_path(image_path)

              -- Check if file exists
              if not absolute_image_path then
                vim.api.nvim_echo(
                  { { "Image file does not exist:\n", "ErrorMsg" }, { absolute_image_path, "ErrorMsg" } },
                  false,
                  {}
                )
                return
              end

              -- Cannot see the popup as the cursor is on top of the image name, so saving
              -- its position, will move it to the top and then move it back
              local current_pos = vim.api.nvim_win_get_cursor(0) -- Save cursor position
              vim.api.nvim_win_set_cursor(0, { 1, 0 }) -- Move to top
              vim.ui.select(
                { "yes", "no" },
                { prompt = "Delete image file? " },
                function(choice)
                  if choice == "yes" then
                    -- Cannot see the popup as the cursor is on top of the image name, so saving
                    -- its position, will move it to the top and then move it back

                    local rm_success, _ = pcall(function()
                     vim.fn.system({ "rm", vim.fn.fnameescape(absolute_image_path) })
                    end)

                    if rm_success and vim.fn.filereadable(absolute_image_path) == 0 then
                      vim.api.nvim_echo({
                        { "Image file deleted from disk:\n", "Normal" },
                        { absolute_image_path, "Normal" },
                      }, false, {})

                      local success, snacks = pcall(require, "snacks")
                      if success then
                        snacks.image.placement.clean()
                      else
                        local success, image = pcall(require, "image")
                        if success then
                          image.clear()
                        end
                      end

                      vim.api.nvim_win_set_cursor(0, current_pos) -- Move back to image line
                      vim.cmd("edit!")
                      vim.cmd("normal! dd")
                    else
                      vim.api.nvim_echo({
                        { "Failed to delete image file:\n", "ErrorMsg" },
                        { absolute_image_path, "ErrorMsg" },
                      }, false, {})
                    end
                  else
                    vim.api.nvim_echo({ { "Image deletion canceled.", "Normal" } }, false, {})
                  end
                end
              )
            end
          '';
          options = {desc = "delete image file under cursor";};
        }
        {
          mode = "n";
          key = "<leader>oo";
          action = ":cd ${first_workspace_path}<cr>:e index.md<cr>";
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
          key = "<leader>oT";
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
        {
          mode = "n";
          key = "<leader>os";
          action = ":Obsidian quick_switch<cr>";
        }
        {
          mode = "n";
          key = "<leader>or";
          action = ":ObsidianRename<cr>";
        }
        {
          mode = "n";
          key = "<leader>ot";
          action = ":Obsidian tags<cr>";
        }
        {
          mode = "n";
          key = "<leader>ob";
          action = ":ObsidianBacklinks<cr>";
        }
        {
          mode = "x";
          key = "<c-o>x";
          action = ":Obsidian extract_note<cr>";
        }
      ];

      plugins = {
        markview = {
          enable = true;
          settings = {
            markdown_inline = {
              checkboxes = {
                enable = true;
                checked = {
                  text = " ";
                  hl = "MarkviewCheckboxChecked";
                  scope_hl = "MarkviewCheckboxChecked";
                };
                unchecked = {
                  text = "󰄱 ";
                  hl = "MarkviewCheckboxUnchecked";
                  scope_hl = "MarkviewCheckboxUnchecked";
                };

                "/" = {
                  text = " ";
                  hl = "MarkviewCheckboxPending";
                };
                ">" = {
                  text = " ";
                  hl = "MarkviewCheckboxCancelled";
                };
                "~" = {
                  text = "󰰱 ";
                  hl = "ObsidianTilde";
                };
                "<" = {
                  text = "󰃖";
                  hl = "MarkviewCheckboxCancelled";
                };
                "-" = {
                  text = "󰍶";
                  hl = "MarkviewCheckboxCancelled";
                  scope_hl = "MarkviewCheckboxStriked";
                };

                "?" = {
                  text = "󰋗";
                  hl = "MarkviewCheckboxPending";
                };
                "!" = {
                  rendered = " ";
                  hl = "ObsidianImportant";
                };
                "*" = {
                  text = "󰓎";
                  hl = "MarkviewCheckboxPending";
                };
                "\"" = {
                  text = "󰸥";
                  hl = "MarkviewCheckboxCancelled";
                };
                "l" = {
                  text = "󰆋";
                  hl = "MarkviewCheckboxProgress";
                };
                "b" = {
                  text = "󰃀";
                  hl = "MarkviewCheckboxProgress";
                };
                "i" = {
                  text = "󰰄";
                  hl = "MarkviewCheckboxChecked";
                };
                "S" = {
                  text = "";
                  hl = "MarkviewCheckboxChecked";
                };
                "I" = {
                  text = "󰛨";
                  hl = "MarkviewCheckboxPending";
                };
                "p" = {
                  text = "";
                  hl = "MarkviewCheckboxChecked";
                };
                "c" = {
                  text = "";
                  hl = "MarkviewCheckboxUnchecked";
                };
                "f" = {
                  text = "󱠇";
                  hl = "MarkviewCheckboxUnchecked";
                };
                "k" = {
                  text = "";
                  hl = "MarkviewCheckboxPending";
                };
                "w" = {
                  text = "";
                  hl = "MarkviewCheckboxProgress";
                };
                "u" = {
                  text = "󰔵";
                  hl = "MarkviewCheckboxChecked";
                };
                "d" = {
                  text = "󰔳";
                  hl = "MarkviewCheckboxUnchecked";
                };
              };
            };
            yaml = {
              properties = {
                "^references$" = {
                  use_types = false;
                  hl = "MarkviewIcon1";
                  text = " 󰖟 ";
                };

                "^id$" = {
                  use_types = false;
                  hl = "MarkviewIcon1";
                  text = "  ";
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
