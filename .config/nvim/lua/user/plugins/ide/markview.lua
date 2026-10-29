-- Toggle the inline preview on the current buffer, with or without hybrid mode
-- (hybrid mode shows the raw markdown on the line being edited)
local function toggle_preview(hybrid)
  local actions = require("markview.actions")
  local buf = vim.api.nvim_get_current_buf()
  local state = require("markview.state").get_buffer_state(buf, false)

  if state and state.enable and (state.hybrid_mode == hybrid) then
    actions.disable(buf)
    return
  end

  actions.enable(buf)
  if hybrid then
    actions.hybridEnable(buf)
  else
    actions.hybridDisable(buf)
  end
end

return {
  "OXY2DEV/markview.nvim",
  -- The plugin lazy-loads itself; the author recommends against lazy.nvim's lazy loading
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    preview = {
      filetypes = { "markdown" },
      -- Don't render automatically, see the keys below
      enable = false,
      -- Modes where hybrid mode applies (only active on buffers with hybrid mode on)
      hybrid_modes = { "n", "i" },
      -- Also un-render the line above the cursor in hybrid mode
      edit_range = { 1, 0 },
    },
  },
  keys = {
    { "<leader>mt", function() toggle_preview(true) end, desc = "Toggle markdown preview (hybrid)" },
    { "<leader>md", function() toggle_preview(false) end, desc = "Toggle markdown preview (no hybrid)" },
    { "<leader>ms", "<cmd>Markview splitToggle<cr>", desc = "Toggle markdown split preview" },
  },
}
