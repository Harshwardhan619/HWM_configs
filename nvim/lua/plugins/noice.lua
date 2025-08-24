return {
  {
    "folke/noice.nvim",
    -- enabled = false,
    opts = {
      cmdline = {
        enabled = true, -- disable cmdline popup
        view = "cmdline", -- use the cmdline view for command input
      },
      messages = {
        enabled = true, -- disable message popup
      },
      popupmenu = {
        enabled = true,
        -- backend = "cmdline", -- position popupmenu in the cmdline
        
      },
    },

    presets = {
      -- you can enable a preset by setting it to true, or a table that will override the preset config
      -- you can also add custom presets that you can enable/disable with enabled=true
      bottom_search = false, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
    }
  },
}
