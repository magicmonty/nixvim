_: {
  plugins.package-info = {
    enable = true;
    enableTelescope = true;
    settings = {
      package_manager = "npm";
      hide_unstable_versions = true;
    };
  };

  keymaps = let
    makemap = key: func: desc: {
      mode = "n";
      inherit key;
      action.__raw = "require('package-info').${func}";
      options = {
        inherit desc;
        silent = true;
        noremap = true;
      };
    };
  in [
    (makemap "<leader>ns" "show" "Show dependency versions")
    (makemap "<leader>nc" "hide" "Hide dependency versions")
    (makemap "<leader>nt" "toggle" "Toggle dependency versions")
    (makemap "<leader>nu" "update" "Update dependency on the line")
    (makemap "<leader>nd" "delete" "Delete dependency on the line")
    (makemap "<leader>ni" "install" "Install a new dependency")
    (makemap "<leader>nv" "change_version" "Install a different dependency version")
  ];
}
