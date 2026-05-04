{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.tex = {
    enable = mkEnableOption ".net support";
  };
  config = let
    inherit (config.sys.lang.tex) enable;
  in
    mkIf enable {
      plugins.vimtex = {
        enable = true;
        texlivePackage = null;
        settings = {
          view_method = "zathura";
        };
      };

      globals = {
        # disable `K` as it conflicts with LSP hover
        vimtext_mappings_disable = {n = ["K"];};

        vimtex_quickfix_method = {__raw = "vim.fn.executable('pplatex') == 1 and 'pplatex' or 'latexlog'";};
      };

      extraPackages = with pkgs; [
        zathura
        python312Packages.pygments
      ];
    };
}
