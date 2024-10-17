{
  description = "Rodolfo's own brand of nvim";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
          plugins: with plugins; [
            python
            ruby
            htmldjango
            html
            javascript
            typescript
            tsx
            svelte
            nix
            json
            dockerfile
            toml
            elixir
            heex
          ]
        );
        myNeovimUnwrapped = pkgs.neovim.override {
          withNodeJs = true;
          configure = {
            customRC = ''
              luafile ${./init.lua}
            '';
            packages.my_packages = {
              start =
                [ treesitter ]
                ++ (with pkgs.vimPlugins; [
                  efmls-configs-nvim

                  nvim-lspconfig
                  nvim-cmp
                  cmp-nvim-lsp
                  cmp-buffer
                  cmp-path
                  cmp-cmdline

                  luasnip
                  vim-fugitive
                  nerdcommenter
                  vim-sleuth
                  vim-surround
                  fzf-vim
                  vim-signify
                  emmet-vim
                  lualine-nvim
                  rose-pine
                ]);
            };
          };
        };
        myNeovim = pkgs.writeShellApplication {
          name = "nvim";
          runtimeInputs = with pkgs; [
            ripgrep

            tailwindcss-language-server
            vscode-langservers-extracted
            typescript-language-server
            pyright
            nixd
            nixfmt-rfc-style

            efm-langserver
            black
            djlint
            fixjson
          ];
          text = ''${myNeovimUnwrapped}/bin/nvim "$@"'';
        };
      in
      {
        defaultPackage = myNeovim;
      }
    );
}
