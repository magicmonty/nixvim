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
        vue_ls.enable = true;
        ts_ls.enable = true;
      };
    };
}
