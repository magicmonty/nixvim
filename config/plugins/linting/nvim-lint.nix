{pkgs, ...}: {
  plugins.lint = {
    enable = true;
    lintersByFt = {
      dockerfile = ["hadolint"];
      markdown = ["markdownlint"];
    };
  };

  extraPackages = with pkgs; [
    hadolint
    markdownlint-cli2
  ];
}
