-- leaderkey
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- clear highlights using <esc>
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- better hjkl movement
vim.keymap.set({ "n", "v" }, "<M-h>", "12h", {})
vim.keymap.set({ "n", "v" }, "<M-j>", "12j", {})
vim.keymap.set({ "n", "v" }, "<M-k>", "12k", {})
vim.keymap.set({ "n", "v" }, "<M-l>", "12l", {})
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to below window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to above window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- navigation
vim.keymap.set("n", "gl", "gi", { remap = false, desc = "Go to last insert" })

-- buffer management
vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "Create a new buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>setlocal buflisted<cr>", { desc = "List current buffer" })
vim.keymap.set("n", "<leader>bh", "<cmd>setlocal nobuflisted<cr>", { desc = "Hide current buffer" })

-- window management
vim.keymap.set("n", "<C-w>n", "<cmd>vnew<cr>", { desc = "Create a new window" })

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- misc
vim.keymap.set("n", "<leader>/", "/<C-r>+", { desc = "Search Last Yank" })
vim.keymap.set("n", "<leader>?", "?<C-r>+", { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>p", '"0p', { desc = "Paste Last Yank" })
vim.keymap.set("n", "<leader>P", '"0P', { desc = "which_key_ignore" })
vim.keymap.set("n", "q", "<Nop>", { desc = "Disable macro recording" })
vim.keymap.set("t", "<C-]>", "<Nop>", { desc = "Intercept tmux prefix" })
-- quick execution
-- vim.keymap.set("n", "<leader>xs", "<cmd>source %<cr>", { desc = "Source current file" })
-- vim.keymap.set("n", "<leader>xlf", "<cmd>luafile %<cr>", { desc = "Execute lua file" })
-- vim.keymap.set("n", "<leader>xll", "<cmd>.lua<cr>", { desc = "Execute lua line" })
-- vim.keymap.set("v", "<leader>xl", ":lua<cr>", { desc = "Execute selection" })

-- del
vim.keymap.del("n", "grn")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grr")
vim.keymap.del("n", "grt")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gO")
