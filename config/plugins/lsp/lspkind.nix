let
  icons = import ../../icons.nix {};
in {
  plugins.lspkind = {
    enable = true;
    settings = {
      mode = "symbol";
      preset = "default";
      symbolMap = {
        inherit (icons.kinds) Copilot Codeium;
      };
    };
  };
}
