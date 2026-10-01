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
      };
    };
}
