{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.tex = {
    enable = mkEnableOption "TeX support";
  };

  config = let
    inherit (config.sys.lang.tex) enable;
    isDarwin = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
  in
    mkIf enable {
      extraPackages = with pkgs; [
        (mkIf (!isDarwin) zathura)
        python312Packages.pygments
      ];

      plugins = {
        lsp.enable = true;

        vimtex = {
          enable = true;
          texlivePackage = null;
          settings = {
            view_method =
              if isDarwin
              then "skim"
              else "zathura";
          };
        };
      };

      globals = {
        # disable `K` as it conflicts with LSP hover
        vimtext_mappings_disable = {n = ["K"];};

        vimtex_quickfix_method = {__raw = "vim.fn.executable('pplatex') == 1 and 'pplatex' or 'latexlog'";};
      };

      lsp.servers.texlab = {
        enable = true;
        config = {
          settings = {
            on_attach.__raw =
              # lua
              ''
                function(client, bufnr)
                  vim.keymap.set("n", "<leader>K", "<plug>(vimtex-doc-package)",{desc = "Vimtex docs", silent = true})
                end
              '';
          };
        };
      };
    };
}
