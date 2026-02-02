{
  config,
  lib,
  pkgs,
  stable,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.dotnet = {
    enable = mkEnableOption ".net support";
  };

  config = let
    inherit (config.sys.lang.dotnet) enable;
  in
    mkIf enable {
      extraPackages = with pkgs; [
        dotnet-sdk_9
        dotnet-sdk_10
        csharpier
        netcoredbg
      ];

      lsp.servers.roslyn_ls = {
        enable = false;
        config = {
          filetypes = ["cs" "razor" "cshtml"];
          settings = {
            "csharp|inlay_hints" = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true;
              csharp_enable_inlay_hints_for_implicit_variable_types = true;

              csharp_enable_inlay_hints_for_lambda_parameter_types = true;
              csharp_enable_inlay_hints_for_types = true;
              dotnet_enable_inlay_hints_for_indexer_parameters = true;
              dotnet_enable_inlay_hints_for_literal_parameters = true;
              dotnet_enable_inlay_hints_for_object_creation_parameters = true;
              dotnet_enable_inlay_hints_for_other_parameters = true;
              dotnet_enable_inlay_hints_for_parameters = true;
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true;
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true;
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true;
            };

            "csharp|code_lens" = {
              dotnet_enable_references_code_lens = true;
            };
          };
        };
      };

      extraConfigLua =
        # lua
        ''
          vim.filetype.add({
            extension = {
              cs = "cs",
              razor = "razor",
              cshtml = "razor",
            }
          })
        '';

      plugins = {
        roslyn = {
          enable = true;
          settings = {
            filewatching = "roslyn";
            silent = true;
            broad_search = true;
            lock_target = true;
          };
        };

        conform-nvim.settings.formatters_by_ft = {
          cs = ["csharpier"];
          razor = ["csharpier"];
          cshtml = ["csharpier"];
        };

        neotest.adapters.dotnet = {
          enable = true;
        };

        dap = {
          adapters.executables = {
            coreclr = {
              command = "${pkgs.netcoredbg}/bin/netcoredbg";
              args = [
                "--interpreter=vscode"
              ];
            };
            netcoredbg = {
              command = "${pkgs.netcoredbg}/bin/netcoredbg";
              args = [
                "--interpreter=vscode"
              ];
            };
          };
          configurations = {
            cs = [
              {
                type = "coreclr";
                name = "Launch - netcoredbg";
                request = "launch";
                program.__raw = ''
                  function ()
                    return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net9.0/', 'file')
                  end
                '';
              }
            ];
          };
        };
      };
    };
}
