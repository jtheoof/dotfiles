return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  -- Defined at startup (before the plugin loads) so tmux-resurrect can run `nvim +SessionRestore`
  init = function()
    vim.api.nvim_create_user_command("SessionRestore", function()
      require("persistence").load()
    end, { desc = "Restore session for the current directory" })
  end,
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
  },
}
