{
  description = "Rodolfo's own brand of nvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:


    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
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
      myNeovimUnwrapped = pkgs.neovim.override {
        withNodeJs = true;
        configure = {
          customRC = builtins.readFile ./init.vim;
          packages.my_packages = with pkgs.vimPlugins; {
            start = [
              coc-nvim
              coc-tsserver
              coc-prettier
              coc-solargraph
              coc-json
              coc-emmet
              coc-git
              coc-docker
              coc-eslint

              vim-fugitive
              nerdcommenter
              vim-sleuth
              vim-surround
              fzf-vim
              vim-signify
              emmet-vim
              lightline-vim
              vim-devicons
              rainbow_parentheses-vim
              iceberg-vim
              vim-polyglot
            ] ++ themes;
          };
        };
      };
      myNeovim = pkgs.writeShellApplication {
        name = "nvim";
        runtimeInputs = [ pkgs.ripgrep ];
        text = ''${myNeovimUnwrapped}/bin/nvim "$@"'';
      };
    in { defaultPackage = myNeovim; }
  );
}
