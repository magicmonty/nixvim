let
  icons = import ../../icons.nix {};
in {
  plugins.lspkind = {
    enable = true;
    cmp.enable = false;
    settings = {
      mode = "symbol";
      preset = "default";
      symbolMap = {
        inherit (icons.kinds) Copilot Codeium;
      };
    };
  };
}
