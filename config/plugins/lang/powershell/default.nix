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
        vim.lsp.config('powershell_es', {
          bundle_path = "${pkgs.vscode-extensions.ms-vscode.powershell}/share/vscode/extensions/ms-vscode.PowerShell/modules"
        })

        vim.lsp.enable('powershell_es')
      '';
  };
}
