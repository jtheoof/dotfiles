local mason = require('mason')
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "tsserver",
  },
})
