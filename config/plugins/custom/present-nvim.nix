{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "present-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "magicmonty";
        repo = "present.nvim";
        rev = "1682e66fadde429360d695e773b2f67fb2b2e013";
        hash = "sha256-VxZjS2dLpa+/4zw8s/oQGaXDwVCvJTq3xN7hUZgJIBo=";
      };
    })
  ];
}
