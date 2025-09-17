return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
      })
    end,
    config = function()
      require("refactoring").setup({
        prompt_func_return_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        prompt_func_param_type = {
          go = false,
          java = false,
          cpp = false,
          c = false,
          h = false,
          hpp = false,
          cxx = false,
        },
        printf_statements = {},
        print_var_statements = {},
      })
      
      -- Load refactoring Telescope extension
      require("telescope").load_extension("refactoring")
      
      -- Keymaps
      vim.keymap.set("x", "<leader>re", ":Refactor extract ", { desc = "Extract Function" })
      vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ", { desc = "Extract Function To File" })
      vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ", { desc = "Extract Variable" })
      vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var", { desc = "Inline Variable" })
      vim.keymap.set("n", "<leader>rI", ":Refactor inline_func", { desc = "Inline Function" })
      vim.keymap.set("n", "<leader>rb", ":Refactor extract_block", { desc = "Extract Block" })
      vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file", { desc = "Extract Block To File" })
      
      -- Telescope refactoring
      vim.keymap.set(
        {"n", "x"},
        "<leader>rr",
        function() require('telescope').extensions.refactoring.refactors() end,
        { desc = "Refactor with Telescope" }
      )
    end,
  }
}