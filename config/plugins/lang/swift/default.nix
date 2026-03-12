{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.sys.lang.swift = {
    enable = mkEnableOption "Swift support";
  };

  config = let
    inherit (config.sys.lang.swift) enable;
  in
    mkIf enable {
      extraPackages = with pkgs; [
        swiftformat
      ];

      extraPlugins = [
        pkgs.vimPlugins."swift-vim"

        (pkgs.vimUtils.buildVimPlugin
          {
            name = "my-plugin";
            src = pkgs.fetchFromGitHub {
              owner = "wojciech-kulik";
              repo = "xcodebuild.nvim";
              rev = "6ee81bcf0334eac180111ac7ac2435d421d1508d";
              hash = "sha256-e1/QTC3XJvib+LVdMJnaPXgq4HJ9JlczHrdTD0/poF0=";
            };
            doCheck = false;
          })
      ];

      extraConfigLua = ''
        require('xcodebuild').setup({});
      '';

      plugins.conform-nvim = {
        settings = {
          formatters_by_ft = {
            swift = ["swiftformat"];
          };
        };
      };

      lsp.servers = {
        sourcekit = {
          enable = true;
          package = null;
          config = {
            cmd = [
              "xcrun"
              "sourcekit-lsp"
            ];
            filetypes = [
              "swift"
              "objective-c"
              "objective-cpp"
            ];
            root_markers = [
              "Package.swift"
              "*.xcodeproj"
              ".git"
            ];
          };
        };
      };
    };
}
