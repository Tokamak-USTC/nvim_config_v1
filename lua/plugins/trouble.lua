return {
  "folke/trouble.nvim",
  evnet = "LspsAttach",
  opts = {
    modes = {
      symbols = {
        max_items = 1000,
        icons = {
          --- @type trouble.Indent.symbols
          indent = {
            last = "╰╴", -- rounded
          },
          folder_closed = " ",
          folder_open = " ",
          kinds = require("global.ui.icons").kinds,
        },
        win = { position = "right", size = 0.25 },
        keys = { s = false },
      },
    },
  }, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    { "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "List Symbols" },
    { "<leader>cd", "<cmd>Trouble diagnostics toggle<cr>", desc = "List Diagnostics" },
  },
}
