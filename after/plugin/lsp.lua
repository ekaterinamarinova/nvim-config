local lsp_zero = require('lsp-zero')

-- Extend default capabilities
lsp_zero.extend_lspconfig()

-- Keymaps
lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
  vim.keymap.set("n", "<leader>vd",  vim.diagnostic.open_float, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
  vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
end)

-- Mason setup
require('mason').setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "rust_analyzer",
    "lua_ls",
    "jdtls",
  },
  automatic_installation = true,
})

-- LSP servers
local lspconfig = require("lspconfig")

-- lua_ls
lspconfig.lua_ls.setup(lsp_zero.nvim_lua_ls())

-- gopls
lspconfig.gopls.setup({
  settings = {
    gopls = {
      gofumpt = true,
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
})

-- Completion
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  formatting = lsp_zero.cmp_format(),
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip'},
    {name = 'buffer'},
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

