return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      vim.treesitter.language.add("lua")

      require("nvim-treesitter").install({
        "lua", "vim", "vimdoc",
        "javascript", "typescript",
        "python", "bash", "json",
        "yaml", "toml", "markdown",
      })
    end
  }
}
