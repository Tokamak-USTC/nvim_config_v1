local patch_flag = "_nvim_sidekick_patched"

local function mark_patched(mod)
  if rawget(mod, patch_flag) then
    return false
  end
  rawset(mod, patch_flag, true)
  return true
end

local function patch_session_sid()
  local ok, Session = pcall(require, "sidekick.cli.session")
  if not ok or not mark_patched(Session) then
    return
  end

  local original_sid = Session.sid
  local nvim_pid = vim.fn.getpid()

  ---@diagnostic disable-next-line: duplicate-set-field
  Session.sid = function(opts)
    return ("%s %d"):format(original_sid(opts), nvim_pid)
  end
end

local function patch_tmux_start()
  local ok, Tmux = pcall(require, "sidekick.cli.session.tmux")
  if not ok or not mark_patched(Tmux) then
    return
  end

  local original_start = Tmux.start

  ---@diagnostic disable-next-line: duplicate-set-field
  Tmux.start = function(self)
    local ret = original_start(self)
    if not self.external and ret and ret.cmd then
      table.insert(ret.cmd, 2, "-f")
      table.insert(ret.cmd, 3, "/dev/null")

      local http = vim.trim(vim.fn.system([[bash -ic 'echo -n $HTTP_PROXY'  2>/dev/null]]))
      local https = vim.trim(vim.fn.system([[bash -ic 'echo -n $HTTPS_PROXY' 2>/dev/null]]))
      if http ~= "" then
        vim.list_extend(ret.cmd, { ";", "setenv", "-g", "HTTP_PROXY", http })
      end
      if https ~= "" then
        vim.list_extend(ret.cmd, { ";", "setenv", "-g", "HTTPS_PROXY", https })
      end

      vim.list_extend(ret.cmd, {
        ";",
        "set-option",
        "destroy-unattached",
        "on",
        ";",
        "set-option",
        "-s",
        "escape-time",
        "0",
      })
    end
    return ret
  end
end

local function patch_sidekick_tmux()
  -- Keep Sidekick-created tmux sessions isolated per nvim process and destroy
  -- them when their embedded terminal client detaches.
  patch_session_sid()
  patch_tmux_start()
end

return {
  "folke/sidekick.nvim",
  init = patch_sidekick_tmux,
  opts = {
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
        create = "terminal",
      },
      tools = {
        codex = { is_proc = false },
        coco = { cmd = { "coco" } },
        traex = { cmd = { "traex" } },
      },
      prompts = {
        -- Global prompts
        chinese = "本次对话请使用中文回复。",
        concise = "本次对话请简洁作答，先给结论，必要时再补充细节。",
        detailed = "本次对话请适当详细说明推理、权衡和实现细节，但避免无关展开。",
        no_modify = "本次对话中，除非我明确要求，否则不要修改文件或直接进行代码改动。",
        ask_first = "本次对话中，如有不明确的需求、意图或边界，请先向我确认，不要自行假设。",
        -- One-shot prompts
        web_search = "对于后续内容，请先进行联网搜索，再结合搜索结果作答。",
        translate = "对于后续内容，请翻译成自然、准确的中文。",
        redo = "请根据刚才已明确的讨论，重新执行上一版修改。",
      },
      win = {
        config = function(terminal)
          if terminal.tool.name == "codex" then
            terminal.opts.split.width = 0.3
          elseif terminal.tool.name == "coco" then
            terminal.opts.split.width = 0.3
          elseif terminal.tool.name == "traex" then
            terminal.opts.split.width = 0.3
          end
        end,
        keys = {
          -- WARN: <Esc> is used here to leave terminal mode, so terminal apps will not receive it.
          -- If sidekick is using tmux as the backend, you can try <C-[> as a substitute for <Esc>.
          -- If that still does not work, try mapping another key to the tool's own exit action instead.
          stopinsert = { "<Esc>", "stopinsert", mode = "t", desc = "Exit Terminal Mode" },
          buffers = { "<C-b>", "buffers", mode = "n", desc = "Open Buffer Picker" },
          files = { "<C-f>", "files", mode = "n", desc = "Open File Picker" },
          hide_ctrl_z = { "<C-z>", "blur", mode = "n", desc = "Blur Terminal Window" },
          prompt = { "<C-p>", "prompt", mode = "n", desc = "Insert Prompt or Context" },
        },
      },
    },
    nes = { enabled = false },
  },
  keys = {
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Toggle CLI",
    },
    {
      "<leader>ah",
      function()
        require("sidekick.cli").hide({ all = true })
      end,
      desc = "Hide All CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach CLI",
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
      desc = "Send Lines",
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
      desc = "Select Prompt",
    },
  },
}
