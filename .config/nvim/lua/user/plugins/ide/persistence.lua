return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  -- Defined at startup (before the plugin loads) so tmux-resurrect can run `nvim +SessionRestore`
  init = function()
    vim.api.nvim_create_user_command("SessionRestore", function()
      require("persistence").load()
    end, { desc = "Restore session for the current directory" })

    -- Restore the session for the current directory when nvim starts without files
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      callback = function()
        if vim.fn.argc(-1) == 0 then
          require("persistence").load()
        end
      end,
    })
  end,
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
  },
}
