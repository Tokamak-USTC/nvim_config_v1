return {
  "saghen/blink.cmp",
  event = { "CmdlineEnter", "InsertEnter" },
  dependencies = { "fang2hou/blink-copilot" },
  version = "1.*",
  opts = {
    keymap = {
      -- preset = "super-tab",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<M-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<M-n>"] = { "select_next", "fallback_to_mappings" },
      ["<M-k>"] = { "select_prev", "fallback_to_mappings" },
      ["<M-j>"] = { "select_next", "fallback_to_mappings" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },
    cmdline = {
      enabled = true,
      keymap = {
        -- recommended, as the default keymap will only show and select the next item
        ["<Tab>"] = { "show", "accept" },
        ["<M-p>"] = { "select_prev", "fallback_to_mappings" },
        ["<M-n>"] = { "select_next", "fallback_to_mappings" },
        ["<M-k>"] = { "select_prev", "fallback_to_mappings" },
        ["<M-j>"] = { "select_next", "fallback_to_mappings" },
      },
      completion = { menu = { auto_show = true } },
    },
    completion = {
      menu = {
        border = "rounded",
        max_height = 12,
        scrollbar = false,
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
    },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "normal",
      kind_icons = require("global.ui.icons").kinds,
    },
  },
}
