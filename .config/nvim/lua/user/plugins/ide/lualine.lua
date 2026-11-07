return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local options = { theme = "nord" }
    if not vim.g.have_nerd_font then
      options.icons_enabled = false
      options.component_separators = { left = "|", right = "|" }
      options.section_separators = { left = "", right = "" }
    end
    require("lualine").setup({ options = options })
  end,
}
