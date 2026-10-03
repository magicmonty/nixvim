{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.yaml = {
    enable = mkEnableOption "YAML support";
  };

  config = let
    inherit (config.sys.lang.yaml) enable;
  in
    mkIf enable {
      extraPackages = with pkgs; [
        yamllint
        yamlfmt
      ];

      plugins = {
        lsp.enable = true;
        schemastore.enable = true;

        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          yaml
        ];

        conform-nvim.settings = {
          formatters = {
            yamllint = {
              command = lib.getExe pkgs.yamllint;
            };
            yamlfmt = {
              command = lib.getExe pkgs.yamlfmt;
            };
          };

          formatters_by_ft = {
            yaml = ["yamllint" "yamlfmt"];
          };
        };
      };

      lsp.servers.yamlls = {
        enable = true;
        config = {
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false;
                lineFollowing = false;
              };
            };
          };
          # lazy-load schemastore when needed
          on_new_config = {
            __raw =
              # lua
              ''
                function(new_config)
                  new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                    "force",
                    new_config.settings.yaml.schemas or {},
                    require("schemastore").yaml.schemas()
                  )
                end
              '';
          };
        };
        config = {
          redhat.telemetry.enabled = false;
          yaml = {
            keyOrdering = false;
            format.enable = true;
            validate = true;
            schemaStore = {
              enable = false;
              url = "";
            };
          };
        };
      };
    };
}
