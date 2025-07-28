{pkgs, ...}: {
  extraPackages = with pkgs; [
    mermaid-cli
    ghostscript
  ];
  plugins.snacks = let
    enabled = {enabled = true;};
  in {
    enable = true;
    settings = {
      bigfile = enabled;
      dashboard = enabled;
      explorer = enabled;
      indent = {
        enabled = true;
        filter.__raw = ''
          function (buf)
            return vim.g.snacks_indent ~= false and
              vim.b[buf].snacks_indent ~= false and
              vim.bo[buf].buftype == "" and
              vim.bo[buf].filetype ~= "markdown"
          end
        '';
      };
      input = enabled;
      picker = enabled;
      quickfile = enabled;
      scope = enabled;
      scroll = enabled;
      statuscolumn = enabled;
      words = enabled;
      image = {
        enabled = true;
        doc = {
          conceal = false;
        };
        convert = {
          notify = false;
        };
      };

      notifier = {
        enabled = true;
        style = "fancy";
      };
    };
  };
}
