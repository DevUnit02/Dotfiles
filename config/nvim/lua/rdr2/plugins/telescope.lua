return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions   = require("telescope.actions")

    telescope.setup({
      defaults = {
        prompt_prefix    = "  ◆ ",
        selection_caret  = " ◆ ",
        entry_prefix     = "   ",
        multi_icon       = " ✦ ",
        path_display     = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width   = 0.55,
          },
        },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
          },
        },
        borderchars = {
          "─", "│", "─", "│", "◆", "◆", "◆", "◆"
        },
      },
    })

    telescope.load_extension("fzf")
  end
}
