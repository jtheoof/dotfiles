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
      -- Needed so the restored buffers trigger BufRead/FileType (filetype detection)
      nested = true,
      callback = function()
        -- Used as a pager (e.g. MANPAGER="nvim +Man!"): stdin is a pipe, so don't touch sessions
        if vim.uv.guess_handle(0) ~= "tty" then
          require("persistence").stop()
        elseif vim.fn.argc(-1) == 0 then
          require("persistence").load()
        end
      end,
    })

    -- Never record man pages in a session (covers `:Man` from inside nvim too)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "man",
      callback = function()
        vim.bo.buflisted = false
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
