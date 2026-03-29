return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = true,
        theme = {
          colors = {
            bg          = "#1a1410",
            bgalt       = "#2a2018",
            fg          = "#d4b878",
            grey        = "#4a3820",
            red         = "#a84030",
            green       = "#8a9a5a",
            yellow      = "#b8922a",
            orange      = "#c87840",
            blue        = "#6a7890",
            cyan        = "#7a9080",
            magenta     = "#8a6050",
            pink        = "#c8a878",
            purple      = "#8a6050",
          }
        }
      })
      vim.cmd("colorscheme cyberdream")
    end
  }
}
