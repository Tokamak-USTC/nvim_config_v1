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
          kinds = {
            Array = " ",
            Boolean = " ",
            Class = " ",
            Constant = " ",
            Constructor = " ",
            Enum = " ",
            EnumMember = " ",
            Event = " ",
            Field = " ",
            File = " ",
            Function = " ",
            Interface = " ",
            Key = " ",
            Method = " ",
            Module = " ",
            Namespace = " ",
            Null = " ",
            Number = " ",
            Object = " ",
            Operator = " ",
            Package = " ",
            Property = " ",
            String = " ",
            Struct = " ",
            TypeParameter = " ",
            Variable = " ",
          },
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
