{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "present-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "tjdevries";
        repo = "present.nvim";
        rev = "ce22dfaf9ebc2b37eb688e00929dfaeff126fe94";
        hash = "sha256-vBmw+BLfFLxBTFJjA29lPGJ3rBMW41O07SfJnDjC0Rk=";
      };
    })
  ];
}
