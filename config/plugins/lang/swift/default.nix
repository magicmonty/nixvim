{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.swift = {
    enable = mkEnableOption "Swift support";
  };

  config = let
    inherit (config.sys.lang.swift) enable;
  in
    mkIf enable {
      extraPackages = with pkgs; [
        swiftformat
        swiftlint
      ];

      extraPlugins = [
        pkgs.vimPlugins."swift-vim"

        (pkgs.vimUtils.buildVimPlugin
          {
            name = "xcodebuild.nvim";
            src = pkgs.fetchFromGitHub {
              owner = "wojciech-kulik";
              repo = "xcodebuild.nvim";
              rev = "6ee81bcf0334eac180111ac7ac2435d421d1508d";
              hash = "sha256-e1/QTC3XJvib+LVdMJnaPXgq4HJ9JlczHrdTD0/poF0=";
            };
            doCheck = false;
          })
      ];

      extraConfigLua = ''
        require('xcodebuild').setup({
            integrations = {
                pymobiledevice = { enabled = true, },
                xcode_build_server = { enabled = true, },
                nvim_tree = { enabled = false, },
                neo_tree = { enabled = false, },
                oil_nvim = { enabled = true, },
                telescope_nvim = { enabled = true, },
                snacks_nvim = { enabled = false, },
                fzf_lua = { enabled = false, },
                codelldb = {
                  enabled = false,
                }
            }
          });


        require("xcodebuild.integrations.dap").setup()
      '';

      autoGroups = {
        lint = {clear = true;};
      };
      autoCmd = [
        {
          callback.__raw = ''
            function()
              if not vim.endswith(vim.fn.bufname(), "swiftinterface") then
                require("lint").try_lint()
              end
            end
          '';
          group = "lint";
          event = [
            "BufWritePost"
            "BufReadPost"
            "InsertLeave"
            "TextChanged"
          ];
        }
      ];
      keymaps = [
        {
          mode = "n";
          key = "<leader>cml";
          action.__raw = ''
            function()
              require("lint").try_lint()
            end
          '';
          options = {desc = "Lint current buffer";};
        }
      ];

      plugins = {
        dap = {
          configurations = {
            swift = [
              {
                cwd = "\${workspaceFolder}";
                name = "Debug";
                request = "launch";
                stopOnEntry = false;
                type = "lldb-dap";
              }
            ];
          };
        };
        dap-lldb = {
          settings = {
            configurations = {
              swift = [
                {
                  cwd = "\${workspaceFolder}";
                  name = "Debug";
                  request = "launch";
                  stopOnEntry = false;
                  type = "lldb-dap";
                }
              ];
            };
          };
        };
        conform-nvim = {
          settings = {
            formatters_by_ft = {
              swift = ["swiftformat"];
            };
          };
        };
        lint = {
          enable = true;
          lintersByFt = {
            swift = ["swiftlint"];
          };
        };
      };

      lsp.servers = {
        sourcekit = {
          enable = true;
          package = null;
          config = {
            cmd = [
              "xcrun"
              "sourcekit-lsp"
            ];
            filetypes = [
              "swift"
              "objective-c"
              "objective-cpp"
            ];
            root_markers = [
              "Package.swift"
              "*.xcodeproj"
              ".git"
            ];
          };
        };
      };
    };
}
