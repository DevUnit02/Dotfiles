-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Cargar plugins
require("lazy").setup({
  spec = {
    { import = "rdr2.plugins.neo-tree" },
    { import = "rdr2.plugins.lualine" },
    { import = "rdr2.plugins.telescope" },
    { import = "rdr2.plugins.theme" },
    { import = "rdr2.plugins.treesitter" },
    { import = "rdr2.plugins.lsp" },
    { import = "rdr2.plugins.cmp" },
  },
  change_detection = { notify = false },
})
