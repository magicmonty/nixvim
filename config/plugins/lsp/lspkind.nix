let
  icons = import ../../icons.nix {};
in {
  plugins.lspkind = {
    enable = true;
    symbolMap = {
      inherit (icons.kinds) Copilot Codeium;
    };
    extraOptions = {
      maxwidth = 50;
      ellipsis_char = "...";
    };
  };
}
