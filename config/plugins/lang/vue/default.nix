{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.vue = {
    enable = mkEnableOption "Vue support";
  };

  config = let
    inherit (config.sys.lang.vue) enable;
  in
    mkIf enable {
      sys.lang.web.enable = mkForce true;
      sys.lang.tailwindcss.enable = mkForce true;

      plugins = {
        lsp.enable = true;

        conform-nvim = {
          settings.formatters_by_ft = {
            vue = ["oxfmt" "oxlint" "prettierd" "prettier"];
            htmlvue = ["oxfmt" "oxlint" "prettierd" "prettier"];
          };
        };
      };

      lsp.servers = {
        vtsls = {
          enable = true;
          config = {
            settings = {
              vtsls = {
                tsserver = {
                  globalPlugins = [
                    {
                      name = "@vue/typescript-plugin";
                      languages = ["vue"];
                      configNamespace = "typescript";
                      enableForWorkspaceTypeScriptVersions = true;
                    }
                  ];
                };
              };
            };
          };
        };

        vue_ls.enable = true;

        oxlint.enable = true;
      };
    };
}
