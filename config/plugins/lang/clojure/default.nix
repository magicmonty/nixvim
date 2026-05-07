{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.clojure = {
    enable = mkEnableOption "clojure support";
  };

  config = let
    inherit (config.sys.lang.clojure) enable;
  in
    mkIf enable {
      plugins = {
        lz-n = {
          enable = true;
        };
        conjure = {
          enable = true;
          lazyLoad = {
            enable = true;
            settings.ft = "clojure";
          };
        };
      };
    };
}
