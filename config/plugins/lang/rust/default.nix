{
  lib,
  config,
  ...
}:
with lib; {
  options.sys.lang.rust = {
    enable = mkEnableOption "rust support";
  };
  config = let
    inherit (config.sys.lang.rust) enable;
  in
    mkIf enable {
      plugins = {
        crates = {
          enable = true;
          settings = {
            lsp = {
              enabled = true;
              name = "crates.nvim";
              on_attach.__raw = ''
                function(client, bufnr)
                  local crates = require("crates")
                  local opts = { silent = true, buffer = bufnr }
                  local function nmap(key, action, desc)
                    vim.keymap.set("n", key, action, { silent = true, buffer = bufnr, desc = desc})
                  end
                  local function vmap(key, action, desc)
                    vim.keymap.set("v", key, action, { silent = true, buffer = bufnr, desc = desc})
                  end

                  nmap("<leader>ct", crates.toggle, "[Crates] - Toggle Crates")
                  nmap("<leader>cr", crates.reload, "[Crates] - Reload Crates")

                  nmap("<leader>cv", crates.show_versions_popup, "[Crates] - Show versions")
                  nmap("<leader>cf", crates.show_features_popup, "[Crates] - Show features")
                  nmap("<leader>cd", crates.show_dependencies_popup, "[Crates] - Show dependencies")

                  nmap("<leader>cu", crates.update_crate, "[Crates] - Update crate")
                  vmap("<leader>cu", crates.update_crates, "[Crates] - Update crates")
                  nmap("<leader>ca", crates.update_all_crates, "[Crates] - Update all crates")
                  nmap("<leader>cU", crates.upgrade_crate, "[Crates] - Upgrade crate")
                  vmap("<leader>cU", crates.upgrade_crates, "[Crates] - Upgrade crates")
                  nmap("<leader>cA", crates.upgrade_all_crates, "[Crates] - Upgrade all crates")

                  nmap("<leader>cx", crates.expand_plain_crate_to_inline_table, "[Crates] - Explain crate")
                  nmap("<leader>cX", crates.extract_crate_into_table, "[Crates] - Extract crate to table")

                  nmap("<leader>cH", crates.open_homepage, "[Crates] - Open homepage")
                  nmap("<leader>cR", crates.open_repository, "[Crates] - Open repository")
                  nmap("<leader>cD", crates.open_documentation, "[Crates] - Open documentation")
                  nmap("<leader>cC", crates.open_crates_io, "[Crates] - Open crates.io")
                  nmap("<leader>cL", crates.open_lib_rs, "[Crates] - Open lib")
                end
              '';
              actions = true;
              completion = true;
              hover = true;
            };
          };
        };
        dap-lldb.enable = true;
        neotest.adapters.rust = {
          enable = true;
        };
        lsp.servers.rust_analyzer = {
          enable = true;
          installRustc = false;
          installCargo = false;
          settings = {
            checkOnSave.command = "clippy";
            inlayHints.lifetimeElisionHints.enable = "always";
          };
        };
        rustaceanvim = {
          enable = false;
          settings = {
            tools = {
              enable_nextest = true;
              enable_clippy = true;
              crate_test_executor = "neotest";
              test_executor = "neotest";
            };
            /*
            server = {
              default_settings = {
                rust-analyzer = {
                  check.command = "clippy";
                  inlayHints = {
                    lifetimeElisionHints = {
                      enable = "always";
                    };
                  };
                };
              };
            };
            */
            standalone = false;
          };
        };
      };
    };
}
