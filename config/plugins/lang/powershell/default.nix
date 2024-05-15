{pkgs, ...}: {
  config = {
    extraPackages = with pkgs; [
      vscode-extensions.ms-vscode.powershell
      powershell
    ];

    extraPlugins = with pkgs.vimPlugins; [
      vim-ps1
    ];

    extraConfigLua =
      # lua
      ''
        require('lspconfig').powershell_es.setup({
          bundle_path = "${pkgs.vscode-extensions.ms-vscode.powershell}/share/vscode/extensions/ms-vscode.PowerShell/modules";
        })
      '';
  };
}
