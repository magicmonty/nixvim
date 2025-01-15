{pkgs, ...}: {
  filetype = {
    extension = {
      http = "http";
    };
  };

  extraFiles."ftplugin/http.lua".text = ''
    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<CR>",
      "<cmd>lua require('kulala').run()<cr>",
      { noremap = true, silent = true, desc = "Execute the request" }
    )

    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "ö",
      "<cmd>lua require('kulala').jump_prev()<cr>",
      { noremap = true, silent = true, desc = "Jump to the previous request" }
    )

    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "ä",
      "<cmd>lua require('kulala').jump_next()<cr>",
      { noremap = true, silent = true, desc = "Jump to the next request" }
    )

    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<leader>i",
      "<cmd>lua require('kulala').inspect()<cr>",
      { noremap = true, silent = true, desc = "Inspect the current request" }
    )

    vim.api.nvim_buf_set_keymap(
      0,
      "n",
      "<leader>t",
      "<cmd>lua require('kulala').toggle_view()<cr>",
      { noremap = true, silent = true, desc = "Toggle between body and headers" }
    )
  '';

  plugins.kulala = {
    enable = true;

    settings = {
      curl_path = "${pkgs.curl}/bin/curl";
      contenttypes = {
        "application/json" = {
          ft = "json";
          formatter = ["jq" "."];
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
