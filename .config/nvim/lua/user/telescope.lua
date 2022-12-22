local telescope = require("telescope")
local config = require("telescope.config")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

local keymap_opt = { silent = true, noremap = true }

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }
-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

local extended = {}

extended.git_or_find_files = function()
  local opts = {} -- define here if you want to define something
  vim.fn.system("git rev-parse --is-inside-work-tree")
  if vim.v.shell_error == 0 then
    builtin.git_files(opts)
  else
    builtin.find_files(opts)
  end
end

vim.keymap.set("n", "<Leader>fa", builtin.find_files, keymap_opt)
vim.keymap.set("n", "<Leader>ff", extended.git_or_find_files, keymap_opt)
vim.keymap.set("n", "<Leader>fd", builtin.diagnostics, keymap_opt)
vim.keymap.set("n", "<Leader>fg", builtin.live_grep, keymap_opt)
vim.keymap.set("n", "<Leader>fb", builtin.buffers, keymap_opt)
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, keymap_opt)
vim.keymap.set("n", "<Leader>fr", telescope.extensions.frecency.frecency, keymap_opt)
vim.keymap.set("n", "<Leader>ft", builtin.treesitter, keymap_opt)
vim.keymap.set("n", "<Leader>fc", builtin.commands, keymap_opt)
vim.keymap.set("n", "<Leader>fq", builtin.quickfix, keymap_opt)
vim.keymap.set("n", "<Leader>fk", builtin.keymaps, keymap_opt)
vim.keymap.set("n", "<Leader>fR", builtin.lsp_references, keymap_opt)
vim.keymap.set("n", "<Leader>fS", builtin.lsp_workspace_symbols, keymap_opt)

vim.keymap.set("n", "<F2>", builtin.buffers, keymap_opt)
vim.keymap.set("n", "<F3>", builtin.find_files, keymap_opt)
vim.keymap.set("n", "<S-F3>", builtin.git_files, keymap_opt)

vim.keymap.set("v", "<Leader>fg", function()
  local selection = vim.get_visual_selection()
  builtin.live_grep({
    default_text = selection,
  })
end, keymap_opt)

telescope.setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },

    layout_strategy = "vertical",
    layout_config = {
      height = 0.95,
      mirror = true,
      prompt_position = "top",
    },

    sorting_strategy = "ascending",

    vimgrep_arguments = vimgrep_arguments,

    mappings = {
      i = {
        ["<Esc>"] = actions.close,

        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<A-Up>"] = actions.cycle_history_prev,
        ["<A-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-Down>"] = actions.cycle_history_next,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,

        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<F36>"] = actions.select_vertical,
        ["<F35>"] = actions.select_horizontal,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = false,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["q"] = actions.close,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<BS>"] = actions.delete_buffer,

        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      previewer = false,
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
    },
    git_files = {
      previewer = false,
      show_untracked = true,
    },
    buffers = {
      sort_mru = true,
    },
  },
  extensions = {},
})
