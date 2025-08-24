return {
  {
    "mbbill/undotree",
    config = function()
      -- Set undotree window layout
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 35
      vim.g.undotree_SetFocusWhenToggle = 1
      
      -- Keymap to toggle undotree
      vim.keymap.set("n", "<leader>uu", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
    end,
  },
}
