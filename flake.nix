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
      ];
      myNeovimUnwrapped = pkgs.neovim.override {
        withNodeJs = true;
        configure = {
          customRC = builtins.readFile ./init.lua;
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
              coc-pyright

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
              rainbow_parentheses-vim
              iceberg-vim
              vim-polyglot
            ] ++ themes;
          };
        };
      };
      myNeovim = pkgs.writeShellApplication {
        name = "nvim";
        runtimeInputs = [ pkgs.ripgrep pkgs.nodejs_16 ];
        text = ''${myNeovimUnwrapped}/bin/nvim "$@"'';
      };
    in { defaultPackage = myNeovim; }
  );
}
