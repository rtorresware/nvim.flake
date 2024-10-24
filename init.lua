vim.o.termguicolors = true
vim.o.background = 'light'
vim.cmd('colorscheme rose-pine')
vim.g.scrollfix = 50
vim.g.mapleader = ' '

vim.o.smartindent = true
vim.o.cmdheight = 2
vim.o.updatetime = 150
vim.o.scrolloff = 9999
vim.o.signcolumn = 'yes'
vim.o.number = true
vim.o.relativenumber = true
vim.o.hlsearch = true
vim.o.wildmenu = true
vim.o.inccommand = 'nosplit'
vim.o.clipboard = 'unnamed'
vim.o.foldmethod = 'syntax'
vim.opt.path:append '**'

vim.api.nvim_set_keymap('i', 'kl', '<Esc>', { noremap = false, silent = true })

vim.api.nvim_set_keymap("", 'j', 'h', { noremap = true, silent = true })
vim.api.nvim_set_keymap("", 'k', 'j', { noremap = true, silent = true })
vim.api.nvim_set_keymap("", 'l', 'k', { noremap = true, silent = true })
vim.api.nvim_set_keymap("", ';', 'l', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<Leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>b', ':Buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>f', ':GFiles<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>af', ':Files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>s', ':Rg<CR>', { noremap = true, silent = true })

require('lualine').setup({
  options = {
    icons_enabled = false,
  }
})
local lspconfig = require('lspconfig')
local cmp = require'cmp'

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<Leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<Leader>F', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
  }),
  sources = cmp.config.sources({
    { name = 'copilot' },
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline('!', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'path' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { 'pyright', 'ts_ls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.nixd.setup({
  settings = {
    nixd = {
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

lspconfig.elixirls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "elixir-ls" },
  settings = { elixirLS = { dialyzerEnabled = false } },
}
lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    tailwindCSS = {
      includeLanguages = {
        elixir = "html",
        eelixir = "html",
      },
      experimental = {
        configFile = os.getenv("TAILWINDCSS_CONFIG_PATH") or "tailwind.config.js"
      },
    },
  },
}

-- Formatting
local djlint = require('efmls-configs.linters.djlint')
local eslint = require('efmls-configs.linters.eslint')
local prettier = require('efmls-configs.formatters.prettier')
local black = require('efmls-configs.formatters.black')
local fixjson = require('efmls-configs.formatters.fixjson')

local fs = require('efmls-configs.fs')
local djlintFormat = {
  formatCommand = string.format(
    "%s --quiet --reformat -",
    fs.executable('djlint')
  ),
  formatCanRange = false,
  formatStdin = true,
}

local languages = {
  typescript = { eslint, prettier },
  typescriptreact = { eslint, prettier },
  javascript = { eslint, prettier },
  javascriptreact = { eslint, prettier },
  python = { black },
  htmldjango = { djlint, djlintFormat },
  json = { fixjson },
}

local efmls_config = {
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { '.git/' },
    languages = languages,
  },
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
}

lspconfig.efm.setup(vim.tbl_extend('force', efmls_config, {
  on_attach = on_attach,
  capabilities = capabilities,
}))
