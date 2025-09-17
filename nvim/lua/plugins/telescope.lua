return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<CR>"] = function(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local actions = require("telescope.actions")
              local entry = action_state.get_selected_entry()
              actions.close(prompt_bufnr)

              -- Get the file path
              local filepath = entry.path or entry.filename or entry.value
              if filepath then
                -- Open in new tab and edit the file properly
                vim.cmd("tabnew")
                vim.cmd("edit " .. vim.fn.fnameescape(filepath))
              end
            end,
          },
          n = {
            ["<CR>"] = function(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local actions = require("telescope.actions")
              local entry = action_state.get_selected_entry()
              actions.close(prompt_bufnr)

              -- Get the file path
              local filepath = entry.path or entry.filename or entry.value
              if filepath then
                -- Open in new tab and edit the file properly
                vim.cmd("tabnew")
                vim.cmd("edit " .. vim.fn.fnameescape(filepath))
              end
            end,
          },
        },
      },
    },
  },
}
