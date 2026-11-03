local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Move between splits
map("n", "<C-h>", "<C-w>h", { desc = "Go to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right split" })

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
