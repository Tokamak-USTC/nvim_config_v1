---@module "snacks"

local outline_layout = {
  layout = {
    box = "horizontal",
    backdrop = false,
    width = 0.75,
    height = 0.85,
    border = "none",
    {
      box = "vertical",
      { win = "input", height = 1, border = true, title = "{title} {live} {flags}", title_pos = "center" },
      { win = "list", border = true },
    },
    {
      win = "preview",
      title = "{preview:Preview}",
      width = 0.65,
      border = true,
      title_pos = "center",
    },
  },
}

---@type snacks.picker.Config
local picker_config = {
  enabled = true,
  layout = "telescope",
  win = {
    input = {
      keys = {
        ["s"] = { "flash" },
        ["<a-k>"] = { "move_12_up" },
        ["<a-j>"] = { "move_12_down" },
      },
    },
    preview = { wo = { wrap = false } },
  },
  icons = { kinds = require("global.ui.icons").kinds },
  actions = {
    flash = function(picker)
      require("flash").jump({
        search = {
          mode = "search",
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
            end,
          },
        },
        action = function(match)
          local idx = picker.list:row2idx(match.pos[1])
          picker.list:_move(idx, true, true)
        end,
      })
    end,
    move_12_up = function(picker)
      picker.list:move(-12, false, true)
    end,
    move_12_down = function(picker)
      picker.list:move(12, false, true)
    end,
  },
  sources = {
    explorer = {
      finder = "explorer",
      supports_live = false,
      follow_file = true,
      win = {
        list = {
          keys = {
            ["."] = "tcd",
            ["z"] = "explorer_close_all",
            ["P"] = false,
            ["<leader>/"] = false,
            ["<c-b>"] = false,
            ["<c-c>"] = false,
            ["<c-f>"] = false,
            ["<c-t>"] = false,
            ["<c-q>"] = false,
            ["<c-j>"] = false,
            ["<c-k>"] = false,
            ["<c-n>"] = false,
            ["<c-p>"] = false,
            ["<c-w>H"] = false,
            ["<c-w>J"] = false,
            ["<c-w>K"] = false,
            ["<c-w>L"] = false,
            ["<s-cr>"] = false,
            ["zb"] = false,
            ["zt"] = false,
            ["zz"] = false,
            ["I"] = false,
            ["H"] = false,
            ["Z"] = false,
            ["]g"] = false,
            ["[g"] = false,
            ["]d"] = false,
            ["[d"] = false,
            ["]w"] = false,
            ["[w"] = false,
            ["]e"] = false,
            ["[e"] = false,
          },
        },
      },
    },
    lsp_symbols = {
      layout = outline_layout,
    },
    treesitter = {
      layout = outline_layout,
    },
  },
}

return {
  "Tokamak-USTC/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    animate = { enabled = false },
    scroll = { enabled = false },
    notifier = {
      enabled = true,
      timeout = 2000,
    },
    statuscolumn = {
      enabled = true,
      folds = { open = true, git_hl = true },
      refresh = 25,
    },
    indent = { enabled = true },
    scope = { enabled = true },
    words = { enabled = true },
    terminal = { enabled = true },
    picker = picker_config,
    lazygit = {
      enabled = true,
      theme = {
        activeBorderColor = { fg = "@comment.warning", bold = true },
        inactiveBorderColor = { fg = "FloatTitle" },
      },
    },
    styles = {
      terminal = {
        keys = {
          term_normal = {
            "<M-n>",
            function()
              vim.cmd("stopinsert")
            end,
            mode = "t",
            expr = false,
            desc = "Escape to normal mode",
          },
        },
      },
      lazygit = {
        backdrop = 100,
      },
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete current buffer", mode = { "n" }, },
    { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers", mode = { "n" }, },
	{ "<C-/>", function() Snacks.terminal() end, desc = "Toggle Terminal", mode = { "n", "t" }, },
	{ "<C-_>", function() Snacks.terminal() end, desc = "Toggle Terminal", mode = { "n", "t" }, },
	{ "<M-n>", function() Snacks.words.jump(vim.v.count1, true) end, desc = "Next Reference", mode = { "n" }, },
	{ "<M-p>", function() Snacks.words.jump(-vim.v.count1, true) end, desc = "Prev Reference", mode = { "n" }, },
    { "<leader>gl", function() Snacks.lazygit() end, desc = "Lazygit", mode = { "n" }, },
    { "<leader>e", function() local rootdir = require("global.utils.rootdir") Snacks.explorer({ cwd = rootdir() }) end, desc = "Explorer Snacks", mode = { "n" }, },
    { "<leader>:", function () Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Find Files", },
    { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Nvim Configs", },
    { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files", },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Live Grep(cwd)" },
    { "<leader>sG", function() Snacks.picker.grep_buffers() end, desc = "Live Grep(Buffers)" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Key Maps" },
    { "<leader>sr", function() Snacks.picker.recent() end, desc = "Recent Files" },
    { "<leader>sp", function() Snacks.picker() end, desc = "Snacks Picker" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Document Symbols" },
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo Comments" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word(cwd)" },
  },
}
