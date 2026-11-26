{
  extraConfigLuaPre = let
    base = import ./base.nix;
    inject = import ./inject.nix;
    root = import ./root.nix;
    ui = import ./ui.nix;
    lsp = import ./lsp.nix;
    lualine = import ./lualine.nix;
    rex = import ./rex.nix;
  in ''
    ${base}
    ${inject}
    ${root}
    ${ui}
    ${lsp}
    ${lualine}
    ${rex}
  '';

  extraConfigLuaPost = "NixVim.root.setup()";
}
