{
  config,
  lib,
  ...
}:
with lib; {
  plugins = {
    rustaceanvim = {
      enable = true;
      settings = {
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
        standalone = false;
      };
    };
  };

  extraConfigLuaPost =
    mkIf config.plugins.neotest.enable
    #lua
    ''
      require('neotest').setup({
          adapters = {
              require('rustaceanvim.neotest')
          }
      })
    '';
}
