{pkgs, ...}: {
  extraPlugins = with pkgs.vimUtils; [
    (buildVimPlugin {
      pname = "schemastore";
      version = "1.0";
      src = pkgs.fetchFromGitHub {
        owner = "b0o";
        repo = "schemastore.nvim";
        rev = "f7cae6f1b38cb296f48ce1a9c5ed1a419d912a42";
        hash = "sha256-FGKDsiDw3VBUNj38JqwkMxI7JxZY0bikS+oMZTGOuVU=";
      };
    })
  ];
}
