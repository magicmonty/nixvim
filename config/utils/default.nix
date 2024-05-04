{
  extraConfigLuaPre = let
    base = import ./base.nix;
    inject = import ./inject.nix;
    root = import ./root.nix;
    ui = import ./ui.nix;
    lsp = import ./lsp.nix;
    lualine = import ./lualine.nix;
  in ''
    ${base}
    ${inject}
    ${root}
    ${ui}
    ${lsp}
    ${lualine}
  '';

  extraConfigLuaPost = "NixVim.root.setup()";
}
