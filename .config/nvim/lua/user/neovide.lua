if vim.fn.exists("g:neovide") then
  local default_font_size = 10
  local guifontsize = default_font_size
  local guifont = "CaskaydiaCove Nerd Font"

  local function adjust_font_size(amount)
    guifontsize = guifontsize + amount
    vim.opt.guifont = { guifont, ":h" .. guifontsize }
  end

  local function reset_font_size()
    guifontsize = default_font_size
    adjust_font_size(0)
  end

  reset_font_size()

  vim.keymap.set("n", "<C-->", function()
    adjust_font_size(-2)
  end)
  vim.keymap.set("n", "<C-=>", function()
    adjust_font_size(2)
  end)
  vim.keymap.set("n", "<C-0>", function()
    reset_font_size()
  end)
end
