return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local colors = {
      bg      = "#1a1410",
      bgalt   = "#2a2018",
      fg      = "#d4b878",
      muted   = "#4a3820",
      gold    = "#b8922a",
      orange  = "#c87840",
      red     = "#a84030",
      green   = "#8a9a5a",
      brown   = "#8a7050",
    }

    local rdr2 = {
      normal = {
        a = { fg = colors.bg,    bg = colors.gold,   gui = "bold" },
        b = { fg = colors.fg,    bg = colors.bgalt },
        c = { fg = colors.brown, bg = colors.bg },
      },
      insert = {
        a = { fg = colors.bg,  bg = colors.green, gui = "bold" },
        b = { fg = colors.fg,  bg = colors.bgalt },
        c = { fg = colors.brown, bg = colors.bg },
      },
      visual = {
        a = { fg = colors.bg,  bg = colors.orange, gui = "bold" },
        b = { fg = colors.fg,  bg = colors.bgalt },
        c = { fg = colors.brown, bg = colors.bg },
      },
      command = {
        a = { fg = colors.bg,  bg = colors.red, gui = "bold" },
        b = { fg = colors.fg,  bg = colors.bgalt },
        c = { fg = colors.brown, bg = colors.bg },
      },
      inactive = {
        a = { fg = colors.muted, bg = colors.bg },
        b = { fg = colors.muted, bg = colors.bg },
        c = { fg = colors.muted, bg = colors.bg },
      },
    }

    require("lualine").setup({
      options = {
        theme = rdr2,
        component_separators = { left = "◆", right = "◆" },
        section_separators   = { left = "", right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end
}
