{
  plugins = {
    dap-lldb.enable = true;
    neotest.adapters.rust = {
      enable = true;
    };
    rustaceanvim = {
      enable = true;
      settings = {
        tools = {
          enable_nextest = true;
          enable_clippy = true;
          crate_test_executor = "neotest";
          test_executor = "neotest";
        };
        /*
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
        */
        standalone = false;
      };
    };
  };
}
