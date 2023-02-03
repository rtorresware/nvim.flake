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
      myNeovim = pkgs.neovim.override {
      withNodeJs = true;
      configure = {
        customRC = ''
colo lucius
set termguicolors
set background=light
let g:lightline = {
      \ 'colorscheme': 'one',
      \ }

"Rainbow
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
let g:rainbow_active = 1
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

set smartindent
filetype plugin on

set cmdheight=2
set updatetime=300
set scrolloff=9999
let g:scrollfix=50
set signcolumn=yes
set inccommand=nosplit

set relativenumber
set number
set hlsearch

set path+=**
set wildmenu
set clipboard=unnamed

set foldmethod=syntax

imap kl <Esc>
tnoremap kl <C-\><C-n>
let mapleader = "\<Space>"
nnoremap j h
vnoremap j h
onoremap j h
nnoremap k j
vnoremap k j
onoremap k j
nnoremap l k
vnoremap l k
onoremap l k
nnoremap ; l
vnoremap ; l
onoremap ; l

nnoremap <Leader>w  :w<CR>
nnoremap <Leader>b  :Buffers<cr>
nnoremap <Leader>f  :Files<cr>
nnoremap <Leader>gf :GFiles<cr>
nnoremap <Leader>gs :GFiles?<cr>
nnoremap <leader>s  :Rg<cr>

"Coc patches
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

vmap <Leader>a <Plug>(coc-codeaction-selected)
nmap <Leader>a <Plug>(coc-codeaction-selected)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> rn <Plug>(coc-rename)

" Formatting
nmap <Leader>F :call CocAction('format')<CR>
" Formatting selected code.
xmap <leader>e  <Plug>(coc-format-selected)
nmap <leader>e  <Plug>(coc-format-selected)
        '';
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
    in {
      packages.neovim = myNeovim;
      defaultPackage = self.packages.${system}.neovim;
    });
}
