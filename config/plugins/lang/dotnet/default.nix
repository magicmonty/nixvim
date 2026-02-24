{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.dotnet = {
    enable = mkEnableOption ".net support";
  };

  config = let
    inherit (config.sys.lang.dotnet) enable;
    lspConfig = {
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
          settings = lspConfig;
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
        blink-cmp.settings.sources.providers.easy-dotnet = {
          name = "easy-dotnet";
          enabled = true;
          module = "easy-dotnet.completion.blink";
          score_offset = 10000;
          async = true;
        };
        easy-dotnet = {
          enable = true;
          settings = {
            lsp = {
              enabled = false;
              preload_roslyn = true; # Start loading roslyn before any buffer is opened
              roslynator_enabled = true; # Automatically enable roslynator analyzer
              easy_dotnet_analyzer_enabled = true; # Enable roslyn analyzer from easy-dotnet-server
              auto_refresh_codelens = true;
              analyzer_assemblies = {}; # Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
              config = lspConfig;
            };
            debugger.bin_path = "${pkgs.netcoredbg}/bin/netcoredbg";
          };
        };
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
