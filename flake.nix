{
  description = "Rodolfo's own brand of nvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      themes = [
        (
          pkgs.vimUtils.buildVimPlugin {
            name = "rose-pine";
            src = pkgs.fetchFromGitHub {
              owner = "rose-pine";
              repo = "neovim";
              rev = "e29002cbee4854a9c8c4b148d8a52fae3176070f";
              sha256 = "bzh6X1pJPe2CM5qDTvadGHD55COTtri+OWzIFlJv9qU=";
            };
          }
        )
        (
          pkgs.vimUtils.buildVimPlugin {
            name = "inspired-github";
            src = pkgs.fetchFromGitHub {
              owner = "mvpopuk";
              repo = "inspired-github.vim";
              rev = "b0f136335ccf832772c01b4c45270139f0fdc543";
              sha256 = "EC81QUDBRcw13vQtgTkicVgh4Q34OC/65+75GVGFqq0=";
            };
          }
        )
      ];
      treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
        python ruby htmldjango html javascript typescript tsx svelte nix json dockerfile toml
      ]);
      myNeovimUnwrapped = pkgs.neovim.override {
        withNodeJs = true;
        configure = {
          customRC = ''
            luafile ${./init.lua}
          '';
          packages.my_packages = with pkgs.vimPlugins; {
            start = [
              efmls-configs-nvim

              tokyonight-nvim

              nvim-lspconfig
              nvim-cmp
              cmp-nvim-lsp
              cmp-buffer
              cmp-path
              cmp-cmdline
              copilot-cmp
              copilot-lua

              luasnip
              vim-fugitive
              nerdcommenter
              vim-sleuth
              vim-surround
              fzf-vim
              vim-signify
              emmet-vim
              lualine-nvim
              treesitter
            ] ++ themes;
          };
        };
      };
      myNeovim = pkgs.writeShellApplication {
        name = "nvim";
        runtimeInputs = with pkgs; [
          ripgrep

          tailwindcss-language-server
          nodePackages.vscode-langservers-extracted
          nodePackages.typescript-language-server
          nodePackages.pyright
          nil

          efm-langserver
          python311Packages.black
        ];
        text = ''${myNeovimUnwrapped}/bin/nvim "$@"'';
      };
    in { defaultPackage = myNeovim; }
  );
}
