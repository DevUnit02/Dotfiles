return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      window = {
        width = 30,
        mappings = {
          ["<space>"] = "none",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = "◆",
          folder_open   = "◇",
          folder_empty  = "○",
        },
        modified = { symbol = "✦" },
        git_status = {
          symbols = {
            added     = "✦",
            modified  = "◆",
            deleted   = "✘",
            renamed   = "➜",
            untracked = "○",
            ignored   = "◌",
            unstaged  = "◈",
            staged    = "●",
            conflict  = "⚔",
          }
        },
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
      },
    })
  end
}
