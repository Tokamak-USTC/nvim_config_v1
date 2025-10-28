return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPost",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "▎" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    signs_staged = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "▎" },
      topdelete = { text = "▎" },
      changedelete = { text = "▎" },
    },
    current_line_blame_opts = { delay = 0 },
  },
  -- stylua: ignore
  keys = {
    { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Blame Line" },
    { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
    { "<leader>gs", "<cmd>Gitsigns select_hunk<cr>", desc = "Select Hunk" },
    { "<leader>gp", "<cmd>Gitsigns preview_hunk_inline<cr>", desc = "Preview Hunk" },
    { "<leader>g<space>", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
    { "]g", function() require("gitsigns").nav_hunk("next", { target = "all" }) end, desc = "Next Hunk" },
    { "[g", function() require("gitsigns").nav_hunk("prev", { target = "all" }) end, desc = "Prev Hunk" },
  },
}
