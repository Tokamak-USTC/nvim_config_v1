return {
  "rebelot/heirline.nvim",
  event = "BufEnter",
  opts = function(_, opts)
    local conditions = require("heirline.conditions")
    local theme = require("tokyonight.colors").setup({ style = "night" })

    local colors = {
      bg = theme.bg,
      fg = theme.fg,
      black = theme.black,
      muted = theme.comment,
      surface = theme.bg_highlight,
      blue = theme.blue,
      cyan = theme.cyan,
      green = theme.green,
      green1 = theme.green1,
      yellow = theme.yellow,
      red = theme.red,
      orange = theme.orange,
      purple = theme.magenta,
      grey = theme.fg_sidebar,
    }

    local mode_names = {
      n = "NORMAL",
      no = "O-PENDING",
      nov = "O-PENDING",
      noV = "O-PENDING",
      ["no\22"] = "O-PENDING",
      niI = "NORMAL",
      niR = "NORMAL",
      niV = "NORMAL",
      nt = "NORMAL",
      ntT = "NORMAL",
      v = "VISUAL",
      vs = "VISUAL",
      V = "V-LINE",
      Vs = "V-LINE",
      ["\22"] = "V-BLOCK",
      ["\22s"] = "V-BLOCK",
      s = "SELECT",
      S = "S-LINE",
      ["\19"] = "S-BLOCK",
      i = "INSERT",
      ic = "INSERT",
      ix = "INSERT",
      R = "REPLACE",
      Rc = "REPLACE",
      Rx = "REPLACE",
      Rv = "V-REPLACE",
      Rvc = "V-REPLACE",
      Rvx = "V-REPLACE",
      c = "COMMAND",
      cv = "EX",
      ce = "EX",
      r = "REPLACE",
      rm = "MORE",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      t = "TERMINAL",
    }

    local mode_colors = {
      n = colors.blue,
      no = colors.blue,
      nov = colors.blue,
      noV = colors.blue,
      ["no\22"] = colors.blue,
      niI = colors.blue,
      niR = colors.blue,
      niV = colors.blue,
      nt = colors.blue,
      ntT = colors.blue,
      v = colors.purple,
      vs = colors.purple,
      V = colors.purple,
      Vs = colors.purple,
      ["\22"] = colors.purple,
      ["\22s"] = colors.purple,
      s = colors.purple,
      S = colors.purple,
      ["\19"] = colors.purple,
      i = colors.green,
      ic = colors.green,
      ix = colors.green,
      R = colors.red,
      Rc = colors.red,
      Rx = colors.red,
      Rv = colors.red,
      Rvc = colors.red,
      Rvx = colors.red,
      c = colors.yellow,
      cv = colors.yellow,
      ce = colors.yellow,
      r = colors.red,
      rm = colors.yellow,
      ["r?"] = colors.yellow,
      ["!"] = colors.green1,
      t = colors.green1,
    }

    local disabled_filetypes = {
      snacks_dashboard = true,
    }

    local update_events = {
      mode = { "ModeChanged", "BufEnter", "WinEnter" },
      file = { "BufEnter", "BufFilePost", "BufModifiedSet", "FileType" },
      cwd = { "DirChanged", "BufEnter", "WinEnter", "FocusGained" },
      cursor = { "CursorMoved", "CursorMovedI", "BufEnter", "WinEnter" },
      lsp = { "DiagnosticChanged", "LspAttach", "LspDetach", "BufEnter", "BufWritePost", "InsertLeave" },
    }

    local user_events = {
      git = { "GitSignsUpdate", "GitSignsChanged" },
    }

    local capsule_presets = {
      left_left = {
        left_sep = "",
        transition_sep = "",
        right_sep = "",
      },
      left_mid = {
        left_sep = "",
        transition_sep = "",
        right_sep = "",
      },
      left_right = {
        left_sep = "",
        transition_sep = "",
        right_sep = "",
        padding = " ",
      },
      right_left = {
        left_sep = "",
        transition_sep = "",
        right_sep = "",
      },
      right_mid = {
        left_sep = "",
        transition_sep = "",
        right_sep = "",
      },
      right_right = {
        left_sep = "",
        transition_sep = "",
        right_sep = "",
      },
    }

    local filetype_icon_fallbacks = {
      snacks_terminal = "",
      sidekick_terminal = "",
      snacks_picker_list = "󰙅",
      snacks_picker_input = "󱡴",
    }

    local align = { provider = "%=" }
    local trunc_point = { provider = "%<" }
    local diagnostic_icons = require("global.ui.icons").diagnostics

    local function safe_call(fn, default, ...)
      local ok, result = pcall(fn, ...)
      if ok then
        return result
      end
      return default
    end

    local function resolve(value, self, default)
      if type(value) == "function" then
        return safe_call(value, default, self)
      end
      if value == nil then
        return default
      end
      return value
    end

    local function extend_opts(base, extra)
      return vim.tbl_extend("force", vim.deepcopy(base), extra or {})
    end

    local function current_directory_name()
      local cwd = vim.fn.getcwd()
      local name = vim.fn.fnamemodify(cwd, ":t")
      if name == nil or name == "" then
        return cwd
      end
      return name
    end

    local function current_file_icon()
      local filetype = vim.bo.filetype
      if filetype ~= "" and _G.MiniIcons and MiniIcons.get then
        local icon, _, is_default = MiniIcons.get("filetype", filetype)
        if icon and not is_default then
          return icon
        end
      end
      if filetype ~= "" and filetype_icon_fallbacks[filetype] then
        return filetype_icon_fallbacks[filetype]
      end
      return "󱀶"
    end

    local function current_buffer_name()
      local filename = vim.api.nvim_buf_get_name(0)
      if filename == "" then
        return "Empty"
      end
      return vim.fn.fnamemodify(filename, ":t")
    end

    local function current_git_status()
      return vim.b.gitsigns_status_dict
    end

    local function has_git_diff(git)
      return git and ((git.added or 0) > 0 or (git.changed or 0) > 0 or (git.removed or 0) > 0)
    end

    local function add_count_item(items, count, prefix, hl)
      if count > 0 then
        items[#items + 1] = { text = prefix .. count, hl = hl }
      end
    end

    local function current_diagnostic_counts()
      local severity = vim.diagnostic.severity
      return {
        error = #vim.diagnostic.get(0, { severity = severity.ERROR }),
        warn = #vim.diagnostic.get(0, { severity = severity.WARN }),
        info = #vim.diagnostic.get(0, { severity = severity.INFO }),
        hint = #vim.diagnostic.get(0, { severity = severity.HINT }),
      }
    end

    local function current_lsp_clients()
      if vim.lsp == nil then
        return {}
      end
      return vim.lsp.get_clients({ bufnr = 0 }) or {}
    end

    local function has_buffer_lsp()
      return not vim.tbl_isempty(current_lsp_clients())
    end

    local function redraw_statusline()
      vim.schedule(function()
        vim.cmd("redrawstatus")
      end)
    end

    local github_status = {
      reachable = nil,
      pending = false,
    }

    local github_connect_timeout_s = "2"
    local github_max_time_s = "4"
    local github_check_interval_ms = 10000

    local github_status_display = {
      checking = { text = "Checking", color = colors.yellow },
      connected = { text = "Connected", color = colors.green1 },
      unreachable = { text = "Unreachable", color = colors.red },
    }

    local function current_github_status_key()
      if github_status.reachable == nil then
        return "checking"
      end
      if github_status.reachable then
        return "connected"
      end
      return "unreachable"
    end

    local function current_github_status_text()
      return github_status_display[current_github_status_key()].text
    end

    local function current_github_status_color()
      return github_status_display[current_github_status_key()].color
    end

    local function refresh_github_status()
      if github_status.pending or vim.fn.executable("curl") == 0 then
        return
      end

      github_status.pending = true
      vim.system({
        "curl",
        "--head",
        "--silent",
        "--fail",
        "--location",
        "--connect-timeout",
        github_connect_timeout_s,
        "--max-time",
        github_max_time_s,
        "https://github.com",
      }, function(result)
        vim.schedule(function()
          github_status.pending = false

          local reachable = result.code == 0
          local changed = github_status.reachable ~= reachable
          github_status.reachable = reachable
          if changed and redraw_statusline then
            redraw_statusline()
          end
        end)
      end)
    end

    local function setup_github_status_checker()
      local uv = vim.uv or vim.loop
      local timer = rawget(vim, "_heirline_github_timer")
      if timer then
        pcall(function()
          timer:stop()
          timer:close()
        end)
      end

      if vim.fn.executable("curl") == 0 then
        github_status.reachable = nil
        return
      end

      timer = uv.new_timer()
      if not timer then
        return
      end

      rawset(vim, "_heirline_github_timer", timer)
      refresh_github_status()
      timer:start(github_check_interval_ms, github_check_interval_ms, vim.schedule_wrap(refresh_github_status))
    end

    local function truncate(str, max_width)
      if not str or str == "" then
        return ""
      end

      if vim.fn.strdisplaywidth(str) <= max_width then
        return str
      end

      return vim.fn.strcharpart(str, 0, math.max(max_width - 1, 1)) .. "…"
    end

    local function stl_escape(str)
      return tostring(str):gsub("%%", "%%%%")
    end

    local trouble_symbols
    -- Lazily create and reuse trouble's statusline adapter for symbol breadcrumbs.
    local function get_trouble_symbols()
      if trouble_symbols ~= nil then
        return trouble_symbols
      end

      local ok, trouble = pcall(require, "trouble")
      if not ok then
        return nil
      end

      trouble_symbols = trouble.statusline({
        mode = "symbols",
        groups = {},
        title = false,
        filter = { range = true },
        format = "{kind_icon}{symbol.name:Normal}",
        hl_group = "StatusLine",
      })

      return trouble_symbols
    end

    local function capsule(capsule_opts)
      return {
        condition = function(self)
          if capsule_opts.init then
            local ok = pcall(capsule_opts.init, self)
            if not ok then
              self._text = ""
              return false
            end
          end

          local enabled = capsule_opts.condition == nil and true or safe_call(capsule_opts.condition, false, self)
          if not enabled then
            self._text = ""
            return false
          end

          local text = resolve(capsule_opts.text, self, "")
          text = text == nil and "" or tostring(text)
          self._text = text
          self._accent = resolve(capsule_opts.accent or capsule_opts.bg, self, colors.surface)
          self._surface = resolve(capsule_opts.surface, self, colors.surface)
          self._icon = resolve(capsule_opts.icon, self, "")
          self._left_sep = resolve(capsule_opts.left_sep, self, "")
          self._transition_sep = resolve(capsule_opts.transition_sep, self, "")
          self._right_sep = resolve(capsule_opts.right_sep, self, "")
          self._padding = resolve(capsule_opts.padding, self, "")
          return text ~= ""
        end,
        update = capsule_opts.update,
        {
          condition = function(self)
            return self._left_sep ~= nil and self._left_sep ~= ""
          end,
          provider = function(self)
            return self._left_sep
          end,
          hl = function(self)
            return { fg = self._accent, bg = "NONE" }
          end,
        },
        {
          condition = function(self)
            return self._icon ~= nil and self._icon ~= ""
          end,
          provider = function(self)
            return self._icon .. " "
          end,
          hl = function(self)
            local icon_fg = resolve(capsule_opts.icon_fg, self, colors.bg)
            return { fg = icon_fg, bg = self._accent, bold = capsule_opts.bold or false }
          end,
        },
        {
          condition = function(self)
            return self._icon ~= nil and self._icon ~= "" and self._transition_sep ~= nil and self._transition_sep ~= ""
          end,
          provider = function(self)
            return self._transition_sep
          end,
          hl = function(self)
            return { fg = self._accent, bg = self._surface, bold = capsule_opts.bold or false }
          end,
        },
        {
          provider = function(self)
            return " " .. self._text .. " "
          end,
          hl = function(self)
            local fg = resolve(capsule_opts.fg, self, self._accent)
            return { fg = fg, bg = self._surface, bold = capsule_opts.bold or false }
          end,
        },
        {
          condition = function(self)
            return self._right_sep ~= nil and self._right_sep ~= ""
          end,
          provider = function(self)
            return self._right_sep
          end,
          hl = function(self)
            return { fg = self._surface, bg = "NONE" }
          end,
        },
        {
          condition = function(self)
            return self._padding ~= nil and self._padding ~= ""
          end,
          provider = function(self)
            return self._padding
          end,
        },
      }
    end

    local function segment(segment_opts)
      local function normalize_items(items, raw_default)
        if items == nil then
          return {}
        end
        if type(items) == "table" then
          local normalized = {}
          for _, item in ipairs(items) do
            if item ~= nil and item ~= "" then
              if type(item) == "table" then
                local text = item.text
                if text ~= nil and text ~= "" then
                  normalized[#normalized + 1] = {
                    text = tostring(text),
                    hl = item.hl,
                    raw = item.raw == nil and raw_default or item.raw,
                  }
                end
              else
                normalized[#normalized + 1] = { text = tostring(item), raw = raw_default }
              end
            end
          end
          return normalized
        end

        local text = tostring(items)
        if text == "" then
          return {}
        end
        return { { text = text, raw = raw_default } }
      end

      local function render_items(items)
        local rendered = {}
        for _, item in ipairs(items) do
          -- `raw` items already contain valid statusline markup, so they must not be escaped.
          local text = item.raw and item.text or stl_escape(item.text)
          if item.hl and item.hl ~= "" then
            rendered[#rendered + 1] = "%#" .. item.hl .. "#" .. text .. "%*"
          else
            rendered[#rendered + 1] = text
          end
        end
        return table.concat(rendered, " ")
      end

      return {
        condition = function(self)
          if segment_opts.init then
            local ok = pcall(segment_opts.init, self)
            if not ok then
              self._items = {}
              return false
            end
          end

          local enabled = segment_opts.condition == nil and true or safe_call(segment_opts.condition, false, self)
          if not enabled then
            self._items = {}
            return false
          end

          local items = resolve(segment_opts.items or segment_opts.text, self, {})
          self._items = normalize_items(items, resolve(segment_opts.raw, self, false))
          self._icon = resolve(segment_opts.icon, self, "")
          self._fg = resolve(segment_opts.fg, self, colors.muted)
          self._icon_fg = resolve(segment_opts.icon_fg, self, self._fg)
          self._padding = resolve(segment_opts.padding, self, "")
          return #self._items > 0
        end,
        update = segment_opts.update,
        {
          condition = function(self)
            return self._icon ~= nil and self._icon ~= ""
          end,
          provider = function(self)
            return self._icon .. " "
          end,
          hl = function(self)
            return { fg = self._icon_fg, bold = segment_opts.bold or false }
          end,
        },
        {
          provider = function(self)
            return render_items(self._items)
          end,
          hl = function(self)
            return { fg = self._fg, bold = segment_opts.bold or false }
          end,
        },
        {
          condition = function(self)
            return self._padding ~= nil and self._padding ~= ""
          end,
          provider = function(self)
            return self._padding
          end,
        },
      }
    end

    local ViMode = capsule(extend_opts(capsule_presets.left_left, {
      init = function(self)
        self.mode = vim.fn.mode(1)
        self.mode_name = mode_names[self.mode] or mode_names[self.mode:sub(1, 1)] or self.mode
        self.mode_color = mode_colors[self.mode] or mode_colors[self.mode:sub(1, 1)] or colors.blue
      end,
      icon = "",
      text = function(self)
        return self.mode_name
      end,
      accent = function(self)
        return self.mode_color
      end,
      icon_fg = colors.black,
      fg = function(self)
        return self.mode_color
      end,
      update = update_events.mode,
    }))

    local Directory = capsule(extend_opts(capsule_presets.left_mid, {
      icon = "󱉭",
      text = function()
        return truncate(current_directory_name(), 40)
      end,
      accent = colors.grey,
      icon_fg = colors.black,
      fg = colors.grey,
      update = update_events.cwd,
    }))

    local FileName = capsule(extend_opts(capsule_presets.left_right, {
      icon = current_file_icon,
      text = function()
        return truncate(current_buffer_name(), 40)
      end,
      accent = colors.red,
      icon_fg = colors.black,
      fg = colors.red,
      update = update_events.file,
    }))

    local function git_status_update(self)
      local git = current_git_status() or {}
      local key = table.concat({
        vim.api.nvim_get_current_buf(),
        git.head or "",
        git.added or 0,
        git.changed or 0,
        git.removed or 0,
      }, ":")

      local changed = self._git_status_key ~= key
      self._git_status_key = key
      return changed
    end

    local Lsp = segment({
      condition = function()
        return has_buffer_lsp()
      end,
      icon = "󰓙",
      text = function()
        local clients = current_lsp_clients()
        if vim.tbl_isempty(clients) then
          return {}
        end

        local names = {}
        local seen = {}
        for _, client in ipairs(clients) do
          if client.name and client.name ~= "" and not seen[client.name] then
            seen[client.name] = true
            names[#names + 1] = client.name
          end
        end

        if vim.tbl_isempty(names) then
          return {}
        end

        return truncate(table.concat(names, ", "), 24)
      end,
      icon_fg = colors.muted,
      fg = colors.muted,
      padding = " ",
      update = update_events.lsp,
    })

    local Diagnostics = segment({
      condition = function()
        return rawget(vim, "diagnostic") ~= nil and has_buffer_lsp()
      end,
      items = function()
        local counts = current_diagnostic_counts()
        local parts = {}
        add_count_item(parts, counts.error, diagnostic_icons.Error .. " ", "DiagnosticError")
        add_count_item(parts, counts.warn, diagnostic_icons.Warn .. " ", "DiagnosticWarn")
        add_count_item(parts, counts.info, diagnostic_icons.Info .. " ", "DiagnosticInfo")
        add_count_item(parts, counts.hint, diagnostic_icons.Hint .. " ", "DiagnosticHint")

        return parts
      end,
      icon_fg = colors.surface,
      fg = colors.purple,
      padding = " ",
      update = update_events.lsp,
    })

    local LspSymbols = segment({
      condition = function()
        local lsp_symbols = get_trouble_symbols()
        return has_buffer_lsp() and vim.b.trouble_lualine ~= false and lsp_symbols and lsp_symbols.has()
      end,
      text = function()
        local lsp_symbols = get_trouble_symbols()
        if not lsp_symbols or not lsp_symbols.has() then
          return {}
        end
        return {
          { text = lsp_symbols.get(), raw = true },
        }
      end,
      icon_fg = colors.cyan,
      fg = colors.grey,
      -- WARN: Intentionally leave `update` unset here.
      -- Keep this component out of heirline's component-level update cache.
      -- trouble.statusline() already drives redrawstatus() on symbol changes.
    })

    local Diff = segment({
      condition = function()
        return has_git_diff(current_git_status())
      end,
      items = function()
        local git = current_git_status()
        if not git then
          return {}
        end

        local parts = {}
        add_count_item(parts, git.added or 0, "+", "GitSignsAdd")
        add_count_item(parts, git.changed or 0, "~", "GitSignsChange")
        add_count_item(parts, git.removed or 0, "-", "GitSignsDelete")

        return parts
      end,
      icon_fg = colors.orange,
      fg = colors.orange,
      padding = " ",
      update = git_status_update,
    })

    local Branch = segment({
      condition = function()
        local git = current_git_status()
        return git and git.head
      end,
      icon = "",
      text = function()
        local git = current_git_status()
        if not git or not git.head then
          return ""
        end

        return truncate(git.head, 32)
      end,
      icon_fg = colors.green,
      fg = colors.green,
      padding = " ",
      update = git_status_update,
    })

    local GitHub = capsule(extend_opts(capsule_presets.right_left, {
      icon = "",
      text = current_github_status_text,
      accent = current_github_status_color,
      icon_fg = colors.black,
      fg = current_github_status_color,
    }))

    local Location = capsule(extend_opts(capsule_presets.right_mid, {
      icon = "",
      text = function()
        local current = vim.fn.line(".")
        local total = vim.fn.line("$")
        local progress = total <= 1 and 0 or math.floor((current / total) * 100)

        return string.format("%d:%d %d%%%%", current, vim.fn.col("."), progress)
      end,
      accent = colors.cyan,
      icon_fg = colors.black,
      fg = colors.cyan,
      update = update_events.cursor,
    }))

    local Clock = capsule(extend_opts(capsule_presets.right_right, {
      icon = "",
      text = function()
        return os.date("%H:%M")
      end,
      accent = colors.blue,
      icon_fg = colors.black,
      fg = colors.blue,
    }))

    local ActiveStatusline = {
      condition = function()
        return conditions.is_active() and not disabled_filetypes[vim.bo.filetype]
      end,
      ViMode,
      Directory,
      FileName,
      Lsp,
      Diagnostics,
      trunc_point,
      LspSymbols,
      align,
      Diff,
      Branch,
      GitHub,
      Location,
      Clock,
    }

    local function apply_statusline_bg()
      local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
      local normal_nc = vim.api.nvim_get_hl(0, { name = "NormalNC", link = false })
      local comment = vim.api.nvim_get_hl(0, { name = "Comment", link = false })

      vim.api.nvim_set_hl(0, "StatusLine", {
        bg = normal.bg,
        fg = normal.fg or comment.fg,
      })

      vim.api.nvim_set_hl(0, "StatusLineNC", {
        bg = normal_nc.bg or normal.bg,
        fg = comment.fg or normal_nc.fg or normal.fg,
      })
    end

    vim.o.laststatus = 3
    vim.o.showmode = false
    setup_github_status_checker()
    apply_statusline_bg()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = apply_statusline_bg,
    })
    vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
      callback = refresh_github_status,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = user_events.git,
      callback = redraw_statusline,
    })
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      callback = redraw_statusline,
    })
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        local timer = rawget(vim, "_heirline_github_timer")
        if timer then
          pcall(function()
            timer:stop()
            timer:close()
          end)
          rawset(vim, "_heirline_github_timer", nil)
        end
      end,
    })

    return {
      statusline = {
        fallthrough = false,
        {
          condition = function()
            return disabled_filetypes[vim.bo.filetype]
          end,
          provider = "",
        },
        {
          condition = conditions.is_active,
          ActiveStatusline,
        },
      },
    }
  end,
}
