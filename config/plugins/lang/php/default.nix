{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.php = {
    enable = mkEnableOption "PHP support";
  };

  config = let
    inherit (config.sys.lang.php) enable;
  in
    mkIf enable {
      extraPackages = with pkgs; [
        phpPackages.php-cs-fixer
        phpPackages.php-codesniffer
        phpPackages.phpinsights
      ];
      plugins = {
        lsp.enable = true;
        treesitter.grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          php
          php_only
          phpdoc
        ];

        conform-nvim.settings.formatters_by_ft = {
          php = ["easy-coding-standard" "php_cs_fixer" "phpcbf" "phpinsights"];
        };
      };

      lsp.servers.phpantom_lsp = {
        enable = true;
        config = {
          cmd = ["phpantom_lsp"];
          filetypes = ["php"];
          root_markers = ["composer.json" ".git"];
        };
      };
    };
}
