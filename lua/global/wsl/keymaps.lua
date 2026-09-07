vim.keymap.set({ "v", "x", "s" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "i", "c" }, "<C-v>", "<C-r>+", { desc = "Paste from system clipboard" })
vim.keymap.set("t", "<C-v>", function()
  local job_id = vim.b.terminal_job_id
  if job_id then
    vim.api.nvim_chan_send(job_id, vim.fn.getreg("+"))
  end
end, { desc = "Paste from system clipboard" })
