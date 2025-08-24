return {
  "stevearc/conform.nvim",
  event = "BufReadPost",
  opts = {
    formatters_by_ft = {
      cpp = { "clang-format" },
      lua = { "stylua" },
      go = { "gofmt" },
      javascript = { "prettier" },
    },
  },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      desc = "Format Code",
    },
  },
}
