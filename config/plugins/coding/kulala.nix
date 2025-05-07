{
  pkgs,
  lib,
  ...
}: {
  filetype = {
    extension = {
      http = "http";
    };
  };

  extraFiles."ftplugin/http.lua".text =
    # lua
    ''
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<CR>",
        "<cmd>lua require('kulala').run()<CR>",
        { noremap = true, silent = true, desc = "Execute the request" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "ö",
        "<cmd>lua require('kulala').jump_prev()<CR>",
        { noremap = true, silent = true, desc = "Jump to the previous request" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "ä",
        "<cmd>lua require('kulala').jump_next()<CR>",
        { noremap = true, silent = true, desc = "Jump to the next request" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>i",
        "<cmd>lua require('kulala').inspect()<CR>",
        { noremap = true, silent = true, desc = "Inspect the current request" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>t",
        "<cmd>lua require('kulala').toggle_view()<CR>",
        { noremap = true, silent = true, desc = "Toggle between body and headers" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>Rc",
        "<cmd>lua require('kulala').copy()<CR>",
        { noremap = true, silent = true, desc = "Copy as cURL" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>Re",
        "<cmd>lua require('kulala').set_selected_env()<CR>",
        { noremap = true, silent = true, desc = "Select environment" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>Ra",
        "<cmd>lua require('kulala.ui.auth_manager').open_auth_config()<CR>",
        { noremap = true, silent = true, desc = "Manage auth config" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>Rx",
        "<cmd>lua require('kulala').scripts_clear_global()<CR>",
        { noremap = true, silent = true, desc = "Clear globals" }
      )

      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<leader>RX",
        "<cmd>lua require('kulala').clear_cached_files()<CR>",
        { noremap = true, silent = true, desc = "Clear cached files" }
      )
    '';

  plugins.kulala = {
    enable = true;

    package = pkgs.vimUtils.buildVimPlugin {
      name = "kulala-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "magicmonty";
        repo = "kulala.nvim";
        rev = "408b482c9ab0b77ff421928278118884d7bf0383";
        hash = "sha256-nVw+/APADdeL6URkOHfFR0DUkLFS5l1EDcnnfNPzeUg="; # lib.fakeHash;
      };
      doCheck = false;
    };

    settings = {
      curl_path = "${pkgs.curl}/bin/curl";
      contenttypes = {
        "application/json" = {
          ft = "json";
          formatter = ["${pkgs.jq}/bin/jq" "."];
          pathresolver = ''require("kulala.parser.jsonpath").parse'';
        };
        "application/xml" = {
          ft = "xml";
          formatter = ["${pkgs.libxml2}/bin/xmllint" "--format" "-"];
          pathresolver = ["${pkgs.libxml2}/bin/xmllint" "--xpath" "{{path}}" "-"];
        };
        "text/html" = {
          ft = "html";
          formatter = ["${pkgs.libxml2}/bin/xmllint" "--format" "--html" "-"];
          pathresolver = {};
        };
      };
    };
  };
}
