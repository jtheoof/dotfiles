-- :Format, the way VS Code's "Format Document" works: pick the formatter from
-- the filetype and let that tool read the project's own config (.prettierrc,
-- stylua.toml, pyproject.toml, .editorconfig). Nothing about a project's style
-- is configured here.
--
-- Install the formatters with the rest of the packages (see install.sh);
-- :ConformInfo lists which ones this buffer found.

-- Formatters that resolved a project root, i.e. whose config file was found up
-- the tree from the file (conform exposes that root as the formatter's `cwd`).
local function configured_formatters(bufnr)
  local names = {}
  for _, formatter in ipairs(require("conform").list_formatters_to_run(bufnr)) do
    if formatter.cwd then
      table.insert(names, formatter.name)
    end
  end
  return names
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    { "<Leader>F", "<Cmd>Format<CR>", mode = { "n", "x" }, desc = "Format buffer or selection" },
    { "<Leader>tf", "<Cmd>FormatToggle<CR>", desc = "Toggle format on save" },
  },
  init = function()
    -- Defined here rather than in config() so :Format exists from the start and
    -- keeps its range on the very first call; requiring conform loads the plugin.
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        -- :'<,'>Format and :N,MFormat format those lines only
        local last = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = { start = { args.line1, 0 }, ["end"] = { args.line2, #last } }
      end
      require("conform").format({ async = true, range = range })
    end, { range = true, desc = "Format the buffer (or range) with its filetype's formatter" })

    vim.api.nvim_create_user_command("FormatToggle", function()
      vim.g.format_on_save = vim.g.format_on_save == false
      vim.notify("Format on save " .. (vim.g.format_on_save == false and "disabled" or "enabled"))
    end, { desc = "Toggle format on save (:Format keeps working either way)" })
  end,
  opts = {
    -- Fall back to a language server when the filetype has no formatter below.
    default_format_opts = { lsp_format = "fallback" },

    -- `autowriteall` plus "FocusLost * wa" (see init.lua) make writes constant
    -- and often unintended, so a save only reformats what the project asked
    -- for: formatters whose own config file is present. Anything else (gofmt,
    -- shfmt, taplo, a bare prettier) waits to be asked with :Format.
    format_on_save = function(bufnr)
      if vim.g.format_on_save == false or vim.b[bufnr].format_on_save == false then
        return
      end
      local formatters = configured_formatters(bufnr)
      if vim.tbl_isempty(formatters) then
        return
      end
      return { formatters = formatters, lsp_format = "never", timeout_ms = 1000 }
    end,

    formatters_by_ft = {
      bash = { "shfmt" },
      css = { "prettier" },
      go = { "gofmt" },
      graphql = { "prettier" },
      html = { "prettier" },
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      less = { "prettier" },
      lua = { "stylua" },
      markdown = { "prettier" },
      python = { "ruff_format" },
      rust = { "rustfmt" },
      scss = { "prettier" },
      sh = { "shfmt" },
      toml = { "taplo" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      yaml = { "prettier" },
      zsh = { "shfmt" },
      -- Everything else: at least drop the trailing whitespace `listchars`
      -- shows. Has no project config, so it never runs on save.
      ["_"] = { "trim_whitespace" },
    },
  },
}
