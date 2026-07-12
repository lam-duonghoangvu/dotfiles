vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Go to Explorer" })

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear highight" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without copy deleted text" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copy deleted text" })
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- Movements
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move Left in Insert Mode" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move Right in Insert Mode" })
vim.keymap.set("i", "<C-j>", "<Down>", { desc = "Move Down in Insert Mode" })
vim.keymap.set("i", "<C-k>", "<Up>", { desc = "Move Up in Insert Mode" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Make Ctrl-C behave the same as Esc in Insert Mode" })
