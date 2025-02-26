{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "present-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "magicmonty";
        repo = "present.nvim";
        rev = "ec81560a8c5330400d557f0b48908721814ea44d";
        hash = "sha256-1gl6f/v3ez88Ap8VCC6r5WCSmFy4dunEH6Q8n04b6mc=";
      };
    })
  ];
}
