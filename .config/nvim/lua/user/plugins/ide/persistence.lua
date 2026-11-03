return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  -- Defined at startup (before the plugin loads) so tmux-resurrect can run `nvim +SessionRestore`
  init = function()
    vim.api.nvim_create_user_command("SessionRestore", function()
      require("persistence").load()
    end, { desc = "Restore session for the current directory" })

    -- Captured now: nvim re-points fd 0 at the tty after reading stdin, so checking
    -- later (e.g. in VimEnter) would always say "tty"
    local piped = vim.uv.guess_handle(0) ~= "tty"

    -- Restore the session for the current directory when nvim starts without files
    vim.api.nvim_create_autocmd("VimEnter", {
      once = true,
      -- Needed so the restored buffers trigger BufRead/FileType (filetype detection)
      nested = true,
      callback = function()
        -- Used as a pager (e.g. MANPAGER="nvim +Man!"): don't touch sessions
        -- +Man! has already filled the buffer by now; that check also covers terminals
        -- where stdin looked like a tty at startup
        local is_man = vim.bo.filetype == "man" or vim.api.nvim_buf_get_name(0):match("^man://") ~= nil
        if piped or is_man then
          require("persistence").stop()
        elseif vim.fn.argc(-1) == 0 then
          require("persistence").load()
        end
      end,
    })

    -- Never record man pages in a session (covers `:Man` from inside nvim too).
    -- :mksession records the buffer shown in a window even if it is unlisted, so close them.
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "man" and #vim.api.nvim_list_wins() > 1 then
            pcall(vim.api.nvim_win_close, win, true)
          end
        end
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].filetype == "man" then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
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
