{pkgs, ...}: {
  keymaps = [
    {
      mode = "n";
      key = "<leader>db";
      action.__raw = "require'dap'.toggle_breakpoint";
      options = {
        desc = "Toggle Breakpoint";
        noremap = true;
      };
    }
    {
      mode = "n";
      key = "<F10>";
      action.__raw = "require'dap'.step_over";
      options = {
        desc = "Debug Step Over";
        noremap = true;
      };
    }
    {
      mode = "n";
      key = "<F11>";
      action.__raw = "require'dap'.step_into";
      options = {
        desc = "Debug Step Into";
        noremap = true;
      };
    }
    {
      mode = "n";
      key = "<F12>";
      action.__raw = "require'dap'.step_out";
      options = {
        desc = "Debug Step Out";
        noremap = true;
      };
    }
    {
      mode = "n";
      key = "<F5>";
      action.__raw = "require'dap'.continue";
      options = {
        desc = "Debug Continue";
        noremap = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      action.__raw = "require'dap'.terminate";
      options = {
        desc = "Terminate Debug Session";
        noremap = true;
      };
    }
  ];
  plugins = {
    dap = {
      enable = true;
      adapters.executables.chrome = let
        vscode-chrome-debug = pkgs.buildNpmPackage {
          name = "vscode-chrome-debug";
          src = pkgs.fetchFromGitHub {
            owner = "Microsoft";
            repo = "vscode-chrome-debug";
            rev = "v4.13.0";
            sha256 = "sha256-JsUVdsen9QMdYnaiQuWBXhPxMn/DazZOuN8df8xpfQ4=";
          };
          npmFlags = [
            "--ignore-scripts"
            "--legacy-peer-deps"
          ];
          npmDepsHash = "sha256-wgD6gop8dAwNDrV6cLZoSbqL1dtGWjNhsjr80jjGXPQ=";

          installPhase = ''
            mkdir -p $out
            cp -r out $out
            cp -r package* $out
            cp -r node_modules $out/node_modules
          '';
        };
      in {
        command = "${pkgs.nodejs-slim_24}/bin/node";
        args = [
          "${vscode-chrome-debug}/out/src/chromeDebug.js"
        ];
      };
      signs = {
        dapBreakpointCondition = {
          text = "󰟃 ";
          texthl = "Error";
          linehl = "";
          numhl = "";
        };
        dapBreakpoint = {
          text = " ";
          texthl = "Error";
          linehl = "";
          numhl = "";
        };
        dapBreakpointRejected = {
          text = " ";
          texthl = "Error";
          linehl = "";
          numhl = "";
        };
        dapStopped = {
          text = " ";
          texthl = "Error";
          linehl = "DapUIBreakpointsLine";
          numhl = "";
        };
        dapLogPoint = {
          text = " ";
          texthl = "Error";
          linehl = "";
          numhl = "";
        };
      };
      luaConfig.post = ''
        require('dap.ext.vscode').load_launchjs(nil, {})
        local dap, dapui = require("dap"), require("dapui")
        dap.listeners.before.attach.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
          dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
          dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
          dapui.close()
        end
      '';
    };
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
  };
}
