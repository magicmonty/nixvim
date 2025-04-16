{
  description = "A nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    language-servers = {
      url = "github:magicmonty/angular-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixvim,
    flake-parts,
    pre-commit-hooks,
    language-servers,
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
        lib,
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              "codeium"
            ];
        };
        lang-servers = language-servers.packages.${system};
        nixvim' = nixvim.legacyPackages.${system};
        nixvimLib = nixvim.lib.${system};

        nixvimModuleFull = {
          inherit pkgs;
          module = ./config/full.nix; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            language-servers = lang-servers;
          };
        };

        nvim = nixvim'.makeNixvimWithModule nixvimModuleFull;

        nixvimModuleLite = {
          inherit pkgs;
          module = ./config/lite.nix; # import the module directly
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            language-servers = lang-servers;
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
            };
        };
      };
    };
}
