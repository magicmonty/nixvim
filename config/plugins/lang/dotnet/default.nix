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
      extraPlugins = with pkgs.vimPlugins; [
        roslyn-nvim
        rzls-nvim
      ];

      extraPackages = with pkgs; [
        dotnet-sdk_9
        csharpier
        netcoredbg
      ];

      extraConfigLua = let
        rzlsPath = "${stable.rzls}/lib/rzls";
        roslyn = "${stable.roslyn-ls}/bin/Microsoft.CodeAnalysis.LanguageServer";
      in
        # lua
        ''
          rzls_path = "${rzlsPath}"
          cmd = {
              "${roslyn}",
              "--stdio",
              "--logLevel=Information",
              "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
              "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
              "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets")
          }

          vim.lsp.config("roslyn", {
            cmd = cmd,
            handlers = require("rzls.roslyn_handlers"),
            settings = {
              ["csharp|inlay_hints"] = {
                csharp_enable_inlay_hints_for_implicit_object_creation = true,
                csharp_enable_inlay_hints_for_implicit_variable_types = true,

                csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                csharp_enable_inlay_hints_for_types = true,
                dotnet_enable_inlay_hints_for_indexer_parameters = true,
                dotnet_enable_inlay_hints_for_literal_parameters = true,
                dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                dotnet_enable_inlay_hints_for_other_parameters = true,
                dotnet_enable_inlay_hints_for_parameters = true,
                dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
              },
              ["csharp|code_lens"] = {
                dotnet_enable_references_code_lens = true,
              },
            },
          })
          vim.lsp.enable("roslyn")

          vim.filetype.add({
            extension = {
              cs = "cs",
              razor = "razor",
              cshtml = "razor",
            }
          })
        '';

      plugins = {
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
