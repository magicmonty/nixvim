# Nixvim config

My Neovim configuration using nixvim.

## Configuring

To start configuring, just add or modify the nix files in `./config`.
If you add a new configuration file, remember to add it to the
[`config/default.nix`](./config/default.nix) file

## Current Plugins

- **Coding**
- **Color scheme**
  - [nvim-autopairs](./config/plugins/coding/autopairs.nix)
  - [nvim-cmp](./config/plugins/coding/cmp.nix)
  - [comment.nvim](./config/plugins/coding/comment.nix)
  - [LuaSnip](./config/plugins/coding/luasnip.nix)
  - [mini.surround](./config/plugins/coding/mini.nix)
- **Editor**
  - [flash](./config/plugins/editor/flash.nix)
  - [gitsigns](./config/plugins/editor/gitsigns.nix)
  - [indent-blankline](./config/plugins/editor/indent.nix)
  - [neo-tree](./config/plugins/editor/neo-tree.nix)
  - [Telescope](./config/plugins/editor/telescope.nix)
  - [Trouble](./config/plugins/editor/trouble.nix)
  - [which-key](./config/plugins/editor/which-key.nix)
- **Formatting**
  - [conform.nvim](./config/plugins/formatting/conform.nix)
- **LSP**
  - [fidget.nvim](./config/plugins/lsp/fidget.nix)
  - [lsp](./config/plugins/lsp/lsp.nix)
  - [lspkind](./config/plugins/lsp/lspkind.nix)
- **Treesitter**
  - [nvim-treesitter](./config/plugins/treesitter/treesitter.nix)
- **UI**
  - [alpha](./config/plugins/ui/alpha.nix)
  - [bufferline](./config/plugins/ui/bufferline.nix)
  - [dressing](./config/plugins/ui/dressing.nix)
  - [lualine](./config/plugins/ui/lualine.nix)
  - [noice](./config/plugins/ui/noice.nix)
  - [nvim-notify](./config/plugins/ui/notify.nix)
  - [ufo](./config/plugins/ui/ufo.nix)

## Testing your new configuration

To test your configuration simply run the following command

```bash
nix run .
```

If you have nix installed, you can directly run my config from anywhere

You can try running mine with:

```shell
nix run 'github:magicmonty/nixvim-config'
```

## Installing into NixOS configuration

This `nixvim` flake will output a derivation that you can easily include
in either `home.packages` for `home-manager`, or
`environment.systemPackages` for `NixOS`. Or whatever happens with darwin?

You can add my `nixvim` configuration as an input to your `NixOS` configuration like:

```nix
{
 inputs = {
    nixvim.url = "github:magicmonty/nixvim-config";
 };
}
```

### Direct installation

With the input added you can reference it directly.

```nix
{ inputs, system, ... }:
{
  # NixOS
  environment.systemPackages = [ inputs.nixvim.packages.${system}.default ];
  # home-manager
  home.packages = [ inputs.nixvim.packages.${system}.default ];
}
```

The binary built by `nixvim` is already named as `nvim` so you can call it just
like you normally would.

### Installing as an overlay

Another method is to overlay your custom build over `neovim` from `nixpkgs`.

This method is less straight-forward but allows you to install `neovim` like
you normally would. With this method you would just install `neovim` in your
configuration (`home.packges = with pkgs; [ neovim ]`), but you replace
`neovim` in `pkgs` with your derivation from `nixvim`.

```nix
{
  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (final: prev: {
        neovim = inputs.nixvim.packages.${system}.default;
      })
    ];
  }
}
```

### Bonus lazy method

You can just straight up alias something like `nix run
'github:magicmonty/nixvim.config'` to `nvim`.

### Bonus extend method

If you want to extend this config is your own NixOS config, you can do so using `nixvimExtend`.
See [here](https://nix-community.github.io/nixvim/modules/standalone.html) for more info.

Example for overwriting the theme

```nix
{
  inputs,
  lib,
  ...
}: let
  nixvim' = inputs.nixvim.packages."x86_64-linux".default;
  nvim = nixvim'.nixvimExtend {
    config.theme = lib.mkForce "jellybeans";
  };
in {
  home.packages = [
    nvim
  ];
}
```

## Credits

Parts of this configuration are based on the following configurations:

- [LazyVim](https://lazyvim.org)
- [elythh's NixVim config](https://github.com/elythh/nixvim)
