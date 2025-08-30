{
  mcphub-nvim,
  pkgs,
  lib,
  ...
}: {
  extraPlugins = [mcphub-nvim];
  extraConfigLua = let
    mcphub-bin = pkgs.buildNpmPackage rec {
      name = "mcp-hub";
      buildInputs = [pkgs.nodejs_latest];
      src = pkgs.fetchFromGitHub {
        owner = "ravitemer";
        repo = "mcp-hub";
        rev = "v4.2.1";
        sha256 = "sha256-KakvXZf0vjdqzyT+LsAKHEr4GLICGXPmxl1hZ3tI7Yg=";
      };
      npmDeps = pkgs.importNpmLock {
        npmRoot = src;
        package = lib.importJSON "${src}/package.json";
        packageLock = lib.importJSON "${src}/package-lock.json";
      };
      inherit (pkgs.importNpmLock) npmConfigHook;

      installPhase = ''
        mkdir $out
        cp dist/* $out
      '';
    };
  in ''
    require("mcphub").setup({
      cmd = "${pkgs.nodejs_latest}/bin/node",
      cmdArgs = { "${mcphub-bin}/cli.js" },
      extensions = {
        copilotchat = {
          enabled = true,
          convert_tools_to_functions = true,
          convert_resources_to_functions = true,
          add_mcp_prefix = false
       }
      }
    })
  '';
}
