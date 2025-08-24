return {
  -- Disable default LazyVim copilot if it exists
  -- { "zbirenbaum/copilot-cmp", enabled = false },
  -- { "github/copilot.vim", enabled = false },
  
  -- Copilot Core with inline suggestions
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>"
          },
          layout = {
            position = "bottom",
            ratio = 0.4
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-l>",        -- Accept suggestion
            accept_word = "<C-w>",   -- Accept word
            accept_line = "<C-j>",   -- Accept line
            next = "<C-]>",          -- Next suggestion
            prev = "<C-[>",          -- Previous suggestion
            dismiss = "<C-\\>",      -- Dismiss
          },
        },
        filetypes = {
          yaml = false,
          markdown = true,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = 'node',
        server_opts_overrides = {},
      })
    end,
  },
  
  -- CopilotChat for agent-like interactions
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require("CopilotChat").setup({
        debug = false,
        window = {
          layout = 'vertical',
          width = 0.5,
          height = 0.5,
        },
      })
    end,
    keys = {
      -- Quick chat - most important one
      { "<leader>cc", function()
        local input = vim.fn.input("Ask Copilot: ")
        if input ~= "" then
          require("CopilotChat").ask(input)
        end
      end, desc = "CopilotChat - Quick Ask" },
      
      -- Essential commands
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "CopilotChat - Fix code" },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "CopilotChat - Optimize code" },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      
      -- Toggle chat window
      { "<leader>cq", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
      
      -- Visual mode - explain selection
      { "<leader>ce", ":CopilotChatExplain<cr>", mode = "v", desc = "CopilotChat - Explain selection" },
      { "<leader>cf", ":CopilotChatFix<cr>", mode = "v", desc = "CopilotChat - Fix selection" },
    },
  },
}
