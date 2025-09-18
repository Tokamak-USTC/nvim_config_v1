return {
  "keaising/im-select.nvim",
  lazy = false,
  opts = {
    default_im_select = "com.apple.keylayout.ABC",
    default_command = "im-select",
    set_default_events = { "InsertLeave", "CmdlineLeave", "TermLeave" },
    set_previous_events = { "InsertEnter", "TermEnter" },
  },
}
