local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navegación entre ventanas
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Redimensionar ventanas
map("n", "<C-Up>",    ":resize +2<CR>")
map("n", "<C-Down>",  ":resize -2<CR>")
map("n", "<C-Left>",  ":vertical resize -2<CR>")
map("n", "<C-Right>", ":vertical resize +2<CR>")

-- Mover líneas en visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

-- Mantener cursor centrado
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Neo-tree
map("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle file explorer" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",    { desc = "Buffers" })

-- Guardar y salir
map("n", "<leader>w", ":w<CR>",  { desc = "Save" })
map("n", "<leader>q", ":q<CR>",  { desc = "Quit" })
map("n", "<leader>x", ":x<CR>",  { desc = "Save and quit" })

-- Limpiar highlights
map("n", "<Esc>", ":nohl<CR>")

-- Tabs
map("n", "<leader>tn", ":tabnew<CR>",   { desc = "New tab" })
map("n", "<leader>tx", ":tabclose<CR>", { desc = "Close tab" })
map("n", "<Tab>",      ":tabnext<CR>")
map("n", "<S-Tab>",    ":tabprev<CR>")
