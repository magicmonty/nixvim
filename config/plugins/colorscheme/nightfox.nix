{
  config,
  lib,
  pkgs,
  ...
}: {
  options.theme = lib.mkOption {
    default = "nightfox";
    type = lib.types.enum ["nightfox" "dayfox" "duskfox" "dawnfox"];
  };

  config = {
    extraPlugins = [pkgs.vimPlugins.nightfox-nvim];
    colorscheme = "${config.theme}";
    extraConfigLua =
      # lua
      ''
        require("nightfox").setup({ options = { transparent = false } })
      '';
  };
}
