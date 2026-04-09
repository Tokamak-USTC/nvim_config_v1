return {
  "folke/sidekick.nvim",
  opts = {
    cli = {
      mux = {
        enabled = false,
      },
      tools = {
        codex = { is_proc = false },
        coco = { cmd = { "coco" } },
      },
      prompts = {
        chinese = "请回复中文",
        english = "Please respond in English",
      },
      win = {
        config = function(terminal)
          if terminal.tool.name == "coco" then
            terminal.opts.split.width = 0.3
          elseif terminal.tool.name == "copilot" then
            terminal.opts.split.width = 80
          elseif terminal.tool.name == "codex" then
            terminal.opts.split.width = 0.3
          end
        end,
        keys = {
          stopinsert = { "<Esc>", "stopinsert", mode = "t", desc = "enter normal mode" },
        },
      },
    },
    nes = { enabled = false },
  },
  keys = {
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle({ name = "codex", focus = true })
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle({ name = "codex", focus = true })
      end,
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      desc = "Select CLI",
    },
    {
      "<leader>al",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send These Lines",
    },
    {
      "<leader>ab",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send Buffer",
    },
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
