{pkgs, ...}: {
  extraPlugins = [pkgs.vimPlugins.nightfox-nvim];
  colorscheme = "nightfox";
  extraConfigLua =
    # lua
    ''
      require("nightfox").setup({ options = { transparent = false } })
    '';
}
