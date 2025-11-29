{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    mcphub-nvim = {
      url = "github:ravitemer/mcphub.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixvim,
    flake-parts,
    pre-commit-hooks,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem = {
        system,
        self',
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              obsidian-nvim-custom = prev.vimUtils.buildVimPlugin {
                name = "obsidian-nvim-custom";
                src = prev.fetchFromGitHub {
                  owner = "obsidian-nvim";
                  repo = "obsidian.nvim";
                  rev = "cc80395d6a710df0aa0faf5d7def46aa0f893e31";
                  hash = "sha256-0vcThntq0uKNO4s4VqBjwtTqS9nn088xnoRzdsNR4t0="; # prev.lib.fakeHash;
                };
                doCheck = false;
              };
            })
          ];
        };
        nixvim' = nixvim.legacyPackages.${system};
        nixvimLib = nixvim.lib.${system};
        mcphub-nvim = inputs.mcphub-nvim.packages.${system}.default;
        stable = inputs.nixpkgs-stable.legacyPackages.${system};

        nixvimModuleFull = {
          inherit pkgs;
          module = ./config/full.nix; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            inherit mcphub-nvim stable;
          };
        };

        nvim = nixvim'.makeNixvimWithModule nixvimModuleFull;

        nixvimModuleLite = {
          inherit pkgs;
          module = ./config/lite.nix; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            inherit mcphub-nvim;
          };
        };

        nvim-lite = nixvim'.makeNixvimWithModule nixvimModuleLite;
        nvim-lite-obsidian = nvim-lite.extend {
          sys.lang.obsidian.enable = true;
        };
      in {
        checks = {
          # Run `nix flake check .` to verify that your config is not broken
          default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModuleFull;

          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              statix.enable = true;
              alejandra.enable = true;
            };
          };
        };

        formatter = pkgs.alejandra;

        # Lets you run `nix run .` to start nixvim
        packages = rec {
          default = full;
          full = nvim;
          lite = nvim-lite;
          lite-obsidian = nvim-lite-obsidian;
        };

        devShells = {
          default = with pkgs;
            mkShell {
              inherit (self'.checks.pre-commit-check) shellHook;
              nativeBuildInputs = [
                pkgs.just
              ];
            };
        };
      };
    };
}
