return {
  "folke/which-key.nvim",
  dependencies = { "echasnovski/mini.icons" },
  event = "VeryLazy",
  opts = {
    preset = "helix",
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>a", group = "Ai", icon = { icon = " ", color = "yellow" } },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "File/Find" },
        { "<leader>g", group = "Git" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Tools", icon = { icon = " ", color = "grey" } },
        { "<leader><Tab>", group = "Tab" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
        {
          "<leader>b",
          group = "Buffer",
          expand = function()
            return require("which-key.extras").expand.buf()
          end,
        },
        {
          "<leader>w",
          group = "Windows",
          proxy = "<C-w>",
          expand = function()
            return require("which-key.extras").expand.win()
          end,
        },
        { "gx", desc = "Open with system app", icon = { icon = "", color = "azure" } },
      },
      {
        mode = { "n" },
        { "<leader>ca", icon = { icon = " ", color = "orange" } },
        { "<leader>e", icon = { icon = " ", color = "red" } },
        { "<leader>gl", icon = { icon = " ", color = "green" } },
        { "<leader>:", icon = { icon = " ", color = "azure" }, desc = "Command History" },
        { "<leader>nd", icon = { icon = " ", color = "red" } },
        { "<leader>z", icon = { icon = " ", color = "green" } },
        { "g,", desc = "Go to newer change position" },
        { "g;", desc = "Go to older change position" },
      },
    },

    icons = {
      rules = {
        { plugin = "snacks.nvim", icon = " ", color = "blue" },
        { plugin = "noice.nvim", pattern = "noice", icon = " ", color = "red" },
        { plugin = "mason.nvim", pattern = "mason", icon = " ", color = "grey" },
        { plugin = "trouble.nvim", icon = " ", color = "orange" },
        { pattern = "explorer", icon = " ", color = "red" },
        { pattern = "terminal", icon = " ", color = "cyan" },
        { pattern = "execute", icon = " ", color = "green" },
        { pattern = "code", icon = " ", color = "orange" },
        { pattern = "buffer", icon = " ", color = "cyan" },
        { pattern = "file", icon = " ", color = "yellow" },
        { pattern = "window", icon = " ", color = "azure" },
        { pattern = "tab", icon = " ", color = "purple" },
        { pattern = "search", icon = " ", color = "blue" },
        { pattern = "paste", icon = " ", color = "purple" },
        { pattern = "git", icon = " ", color = "green" },
        { pattern = "lazy", icon = "󰒲 ", color = "grey" },
        { pattern = "session", icon = " ", color = "azure" },
        { pattern = "change", icon = " ", color = "orange" },
        { pattern = "rename", icon = " ", color = "orange" },
        { pattern = "left", icon = " ", color = "azure" },
        { pattern = "right", icon = " ", color = "azure" },
      },
    },
  },
}
