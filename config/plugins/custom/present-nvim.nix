{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "present-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "magicmonty";
        repo = "present.nvim";
        rev = "a9a5c995fc4d92ae67ec9db5708f70a17f63736f";
        hash = "sha256-KlFClFPYgTerFQ75aX3zkLxFvSDKQXoSzWE+C4AkAZM=";
      };
    })
  ];
}
