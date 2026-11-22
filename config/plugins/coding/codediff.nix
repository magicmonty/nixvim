{lib, ...}: let
  reviewLua =
    # lua
    ''
      local function git_root()
        local name = vim.api.nvim_buf_get_name(0)
        local start = name ~= "" and vim.fs.dirname(name) or vim.uv.cwd()
        return (start and vim.fs.root(start, ".git")) or vim.uv.cwd()
      end

      local function git_ref_exists(root, ref)
        local result = vim.system(
          { "git", "rev-parse", "--verify", "--quiet", ref },
          { cwd = root, text = true }
        ):wait()
        return result.code == 0
      end

      local function review_base(root)
        local result = vim.system(
          { "git", "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD" },
          { cwd = root, text = true }
        ):wait()

        if result.code == 0 then
          local ref = vim.trim(result.stdout or "")
          if ref ~= "" then
            return ref
          end
        end

        for _, ref in ipairs({ "origin/main", "origin/master", "main", "master" }) do
          if git_ref_exists(root, ref) then
            return ref
          end
        end

        return nil
      end

      local function with_review_base(callback)
        local root = git_root()
        local base = review_base(root)
        if not base then
          vim.notify("Could not determine the default review branch", vim.log.levels.ERROR)
          return
        end
        callback(base, root)
      end

      vim.api.nvim_create_user_command("CodeReviewBranch", function()
        with_review_base(function(base)
          vim.cmd("CodeDiff " .. vim.fn.fnameescape(base .. "..."))
        end)
      end, { desc = "Review branch and working-tree changes against their merge base" })

      vim.api.nvim_create_user_command("CodeReviewHistory", function()
        with_review_base(function(base, root)
          local result = vim.system(
            { "git", "rev-list", "--count", base .. "..HEAD" },
            { cwd = root, text = true }
          ):wait()
          local count = result.code == 0 and tonumber(vim.trim(result.stdout or "")) or nil

          if count == 0 then
            vim.notify(
              "No branch commits yet; uncommitted changes are available under Review branch (D)",
              vim.log.levels.INFO
            )
            return
          elseif count == nil then
            vim.notify("Could not determine branch history", vim.log.levels.ERROR)
            return
          end

          vim.cmd("CodeDiff history " .. vim.fn.fnameescape(base .. "..HEAD") .. " --reverse")
        end)
      end, { desc = "Review branch commits in chronological order" })
    '';
in {
  plugins.codediff = {
    enable = true;
    settings = {
      diff = {
        layout = "side-by-side";
        compact = true;
        compact_context_lines = 4;
        compute_moves = true;
        cycle_hunks_across_files = true;
        disable_inlay_hints = true;
        jump_to_first_change = true;
      };
      explorer = {
        width = 50;
        auto_open_on_cursor = true;
        initial_focus = "explorer";
        view_mode = "tree";
        line_stats.enabled = true;
      };
      history = {
        initial_focus = "history";
        view_mode = "tree";
      };
      keymaps = {
        conflict = {
          accept_all_both = "<leader>cB";
          accept_all_current = "<leader>cO";
          accept_all_incoming = "<leader>cT";
          accept_both = "<leader>cb"; # accept both changes
          accept_current = "<leader>co"; # accept our changes
          accept_incoming = "<leader>ct"; # accept their changes
          diffget_current = false;
          diffget_incoming = false;
          discard = false;
          discard_all = false;
        };
        view = {
          diff_get = "do";
          diff_put = "dp";
          discard_hunk = false;
          stage_hunk = false;
          toggle_stage = false;
          unstage_hunk = false;
        };
        explorer = {
          restore = false;
          stage_all = false;
          unstage_all = false;
        };
      };
    };
  };

  extraConfigLua = lib.mkAfter reviewLua;

  keymaps = [
    {
      mode = "n";
      key = "<leader>dv";
      action = "<cmd>CodeDiff<cr>";
      options = {
        desc = "Review working tree";
      };
    }
    {
      mode = "n";
      key = "<leader>dr";
      action = "<cmd>CodeReviewBranch<cr>";
      options = {
        desc = "Review branch changes";
      };
    }
    {
      mode = "n";
      key = "<leader>dh";
      action = "<cmd>CodeReviewHistory<cr>";
      options = {
        desc = "Review branch history";
      };
    }
    {
      mode = "n";
      key = "<leader>dH";
      action = "<cmd>CodeDiff history<cr>";
      options = {
        desc = "Review all history";
      };
    }
  ];
}
