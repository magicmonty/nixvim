{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.markdown = {
    enable = mkEnableOption "enable markdown";
    lsp.enable = mkEnableOption "enable markdown LSP";
    preview.enable = mkEnableOption "enable markdown preview";
  };

  config = let
    inherit (config.sys.lang.markdown) enable;
    enable_lsp = config.sys.lang.markdown.lsp.enable;
    enable_preview = config.sys.lang.markdown.preview.enable;
  in
    mkIf enable {
      extraPackages = mkIf (config.nixvim.flavour != "lite") [
        pkgs.mermaid-cli
        pkgs.ghostscript
        pkgs.markdownlint-cli
      ];

      plugins = {
        markdown-preview.enable = enable_preview;

        lint = {
          lintersByFt = {
            markdown = ["markdownlint"];
          };
        };

        conform-nvim.settings.formatters_by_ft = {
          markdown = ["markdownlint"];
        };

        headlines = let
          headline_highlights = [
            "Headline1"
            "Headline2"
            "Headline3"
            "Headline4"
            "Headline5"
            "Headline6"
          ];

          default_settings = {
            inherit headline_highlights;
            # disable bullets for now. See https://github.com/lukas-reineke/headlines.nvim/issues/66
            bullets = false;
          };
        in {
          enable = false;
          settings = {
            markdown = default_settings;
            norg = default_settings;
            rmd = default_settings;
            org = default_settings;
          };
        };
      };

      highlight = {
        Headline1.link = "Headline";
        Headline2.link = "Headline";
        Headline3.link = "Headline";
        Headline4.link = "Headline";
        Headline5.link = "Headline";
        Headline6.link = "Headline";
      };

      autoCmd = [
        {
          event = "FileType";
          pattern = ["markdown"];
          callback = {
            __raw =
              # lua
              ''
                function()
                  local bufnr = vim.api.nvim_get_current_buf()
                  vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", { noremap = true, silent = true, desc = "Markdown Preview", buffer = bufnr })
                end
              '';
          };
        }
      ];

      lsp.servers.marksman.enable = enable_lsp;
    };
}
