{
  description = "Rodolfo's own brand of nvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tailwindLsp = pkgs.buildNpmPackage {
        name = "_at_tailwindcss_language_server";
        packageName = "@tailwindcss/language-server";
        version = "0.0.13";

        src = pkgs.fetchurl {
          url = "https://registry.npmjs.org/@tailwindcss/language-server/-/language-server-0.0.13.tgz";
          sha512 = "C5OKPG8F6IiSbiEgXMxskMsOnbzSGnZvKBxEGHUhBGIB/tlX5rc7Iv/prdwYrUj2Swhjj5TrXuxZgACo+blB4A==";
        };

        npmDepsHash = "sha256-AaAil2VdYp7OAM5QQ9cwyLEltwrfOrSrMT9/HpHowBY=";
        buildInputs = [ pkgs.nodejs ];
        dontNpmBuild = true;
        postPatch = ''
          cp ${./tailwind-package-lock.json} ./package-lock.json
        '';
      };
      themes = [
        (
          pkgs.vimUtils.buildVimPlugin {
            name = "vim-lucius";
            src = pkgs.fetchFromGitHub {
              owner = "jonathanfilip";
              repo = "vim-lucius";
              rev = "b5dea9864ae64714da4635993ad2fc2703e7c832";
              sha256 = "FlSqTEQyYm17vR7sNw5hlq2Hpz1cWYr23ARsVNibUBM=";
            };
          }
        )
        (
          pkgs.vimUtils.buildVimPlugin {
            name = "rose-pine";
            src = pkgs.fetchFromGitHub {
              owner = "rose-pine";
              repo = "neovim";
              rev = "d149980cfa5cdec487df23b2e9963c3256f3a9f3";
              sha256 = "FlSqTEQyYm17vR7sNw5hlq2Hpz1cWYr23ARsVNibUBM=";
            };
          }
        )
      ];
      myNeovimUnwrapped = pkgs.neovim.override {
        withNodeJs = true;
        configure = {
          customRC = ''
            luafile ${./init.lua}
          '';
          packages.my_packages = with pkgs.vimPlugins; {
            start = [
              nvim-lspconfig
              nvim-cmp
              cmp-nvim-lsp
              cmp-buffer
              cmp-path
              cmp-cmdline

              copilot-vim
              vim-fugitive
              nerdcommenter
              vim-sleuth
              vim-surround
              fzf-vim
              vim-signify
              emmet-vim
              lightline-vim
              vim-devicons

              nvim-treesitter
              nvim-treesitter-parsers.python
              nvim-treesitter-parsers.ruby
              nvim-treesitter-parsers.htmldjango
              nvim-treesitter-parsers.html
              nvim-treesitter-parsers.javascript
              nvim-treesitter-parsers.typescript
              nvim-treesitter-parsers.tsx
              nvim-treesitter-parsers.svelte
              nvim-treesitter-parsers.nix
              nvim-treesitter-parsers.json
              nvim-treesitter-parsers.dockerfile
              nvim-treesitter-parsers.toml
            ] ++ themes;
          };
        };
      };
      myNeovim = pkgs.writeShellApplication {
        name = "nvim";
        runtimeInputs = with pkgs; [
          ripgrep
          nodejs_16

          nodePackages.vscode-langservers-extracted
          nodePackages.typescript-language-server
          nodePackages.pyright
          nil
          tailwindLsp
        ];
        text = ''${myNeovimUnwrapped}/bin/nvim "$@"'';
      };
    in { defaultPackage = myNeovim; }
  );
}
