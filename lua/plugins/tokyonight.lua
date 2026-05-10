return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  init = function()
    vim.cmd.colorscheme("tokyonight-night")
  end,
  opts = {
    on_highlights = function(hl, c)
      -- telescope
      hl.TelescopeNormal = { bg = c.bg }
      hl.TelescopeBorder = { fg = c.border }
      -- hl.TelescopeBorder = { fg = c.border_highlight }
      hl.TelescopeTitle = { fg = c.border_highlight }
      hl.TelescopePromptBorder = { fg = c.border_highlight }
      hl.TelescopePromptTitle = { fg = c.border_highlight }

      -- blink-cmp
      hl.BlinkCmpMenu = { bg = c.bg }
      hl.BlinkCmpMenuBorder = { fg = c.border }
      -- hl.BlinkCmpMenuBorder = { fg = c.border_highlight }
      hl.BlinkCmpDoc = { bg = c.bg }
      hl.BlinkCmpDocBorder = { fg = c.border }
      -- hl.BlinkCmpDocBorder = { fg = c.border_highlight }

      -- which-key
      hl.WhichKeyNormal = { bg = c.bg }
      hl.WhichkeyBorder = { fg = c.border }
      -- hl.WhichkeyBorder = { fg = c.border_highlight }
      hl.WhichKeyTitle = { fg = c.border_highlight }

      -- noice
      hl.NoicePopup = { bg = c.bg }
      hl.NoicePopupBorder = { fg = c.border }
      -- hl.NoicePopupBorder = { fg = c.border_highlight }

      -- snacks
      -- hl.SnacksNormal = { bg = c.bg }
      hl.SnacksPickerInputBorder = { fg = c.border_highlight }
      hl.SnacksPickerInputTitle = { fg = c.border_highlight, bg = c.bg }
      hl.SnacksPickerBoxTitle = { fg = c.border_highlight, bg = c.bg }
      hl.SnacksPickerInputFooter = { fg = c.border_highlight, bg = c.bg }
      hl.SnacksDashboardLogo = { fg = "#30D7FF" }
      hl.SnacksDashboardText = { fg = "#1FB7E0" }
      hl.SnacksDashboardDesc = { fg = "#1FB7E0" }
      hl.SnacksDashboardIcon = { fg = "#1FB7E0" }
      hl.SnacksDashboardKey = { fg = "#1FB7E0" }
      hl.SnacksDashboardFooter = { fg = "#1FB7E0" }
      hl.SnacksDashboardSpecial = { fg = "#1FB7E0" }

      -- trouble
      hl.TroubleNormal = { bg = c.bg }

      -- global
      hl.Normal = { bg = c.bg }
      hl.NormalFloat = { bg = c.bg }
      hl.NormalNC = { bg = c.bg }
      hl.NormalSB = { bg = c.bg }
      hl.FloatBorder = { fg = c.border }
      -- hl.FloatBorder = { fg = c.border_highlight }
      hl.FloatTitle = { fg = c.border_highlight }
    end,
  },
}
