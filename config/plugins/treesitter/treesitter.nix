{pkgs, ...}: {
  plugins = {
    treesitter = {
      enable = true;
      folding.enable = true;
      nixGrammars = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        bibtex
        bicep
        c
        cmake
        comment
        commonlisp
        cpp
        css
        csv
        diff
        dockerfile
        dot
        editorconfig
        embedded_template
        git_config
        git_rebase
        gitattributes
        gitcommit
        gitignore
        gpg
        graphql
        heex
        html
        http
        hyprlang
        java
        javadoc
        jq
        just
        kotlin
        latex
        llvm
        make
        markdown
        markdown_inline
        mermaid
        nginx
        ninja
        nix
        nu
        objc
        passwd
        pem
        perl
        po
        pod
        powershell
        printf
        properties
        proto
        rasi
        razor
        readline
        regex
        requirements
        robot
        ruby
        scala
        scheme
        scss
        sql
        ssh_config
        supercollider
        superhtml
        svelte
        swift
        terraform
        todotxt
        toml
        tsv
        tsx
        udev
        vim
        vimdoc
        vue
        xml
        xresources
        zig
      ];
      nixvimInjections = true;
      settings = {
        indent.enable = false;
        highlight.enable = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-V>";
            node_decremental = "<BS>";
            node_incremental = "<C-V>";
          };
        };
      };
    };

    rainbow-delimiters.enable = true;
  };
}
