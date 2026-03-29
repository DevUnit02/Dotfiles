local opt = vim.opt

-- Números de línea
opt.number = true
opt.relativenumber = true

-- Indentación
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Apariencia
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8

-- Transparencia — el fondo lo da kitty
opt.pumblend = 10
opt.winblend = 10

-- Búsqueda
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Split
opt.splitright = true
opt.splitbelow = true

-- Misc
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- Transparencia y bordes RDR2
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    -- Fondo transparente
    vim.api.nvim_set_hl(0, "Normal",       { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat",  { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC",     { bg = "none" })

    -- Bordes dorados
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#5a4520", bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder",  { fg = "#b8922a", bg = "none" })

    -- Línea del cursor
    vim.api.nvim_set_hl(0, "CursorLine",   { bg = "#2a2018" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#b8922a", bold = true })

    -- Números de línea
    vim.api.nvim_set_hl(0, "LineNr",       { fg = "#4a3820" })

    -- Neo-tree
    vim.api.nvim_set_hl(0, "NeoTreeNormal",       { bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC",     { bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#5a4520", bg = "none" })
  end
})
