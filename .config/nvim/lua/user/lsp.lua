-- local rt = require("rust-tools")
--
local lspconfig = require("lspconfig")

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
-- vim.keymap.set("n", "<Leader>dd", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<Leader>dl", vim.diagnostic.setloclist, opts)
vim.keymap.set("n", "<Leader>dq", vim.diagnostic.setqflist, opts)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
  -- vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
  vim.keymap.set("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
  -- vim.keymap.set("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
  vim.keymap.set("n", "<Leader>ca", "<Cmd>Lspsaga code_action<CR>", opts) -- see available code actions
  vim.keymap.set("n", "<M-Enter>", "<Cmd>Lspsaga code_action<CR>", opts)
  vim.keymap.set("n", "<Leader>lr", "<Cmd>Lspsaga rename<CR>", opts) -- smart rename
  vim.keymap.set("n", "<Leader>D", "<Cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
  vim.keymap.set("n", "<Leader>dd", "<Cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
  vim.keymap.set("n", "[d", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
  vim.keymap.set("n", "]d", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
  vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
  -- vim.keymap.set("n", "<Leader>o", "<Cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
  -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<Leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workLeader_folders()))
  end, bufopts)
  -- vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "<Leader>F", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)

end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 1,
}
lspconfig.tsserver.setup({
  on_attach = on_attach,
  flags = lsp_flags,
})

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = {},
  },
})

lspconfig.lua_ls.setup({
  on_attach = on_attach,
  flags = lsp_flags,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
})

-- rt.setup({
--   server = {
--     on_attach = function(_, bufnr)
--       -- Hover actions
--       vim.keymap.set("n", "<C-Space>", rt.hover_actions.hover_actions, { buffer = bufnr })
--       -- Code action groups
--       vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
--     end,
--   },
-- })
